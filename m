Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYFTLfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYFTLfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYFTLfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:35:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33547 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYFTLfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:35:11 -0400
Date: Fri, 20 Jun 2008 13:34:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCHv6] SGI UV: TLB shootdown using broadcast assist unit -
	v6 delta
Message-ID: <20080620113457.GF7439@elte.hu>
References: <E1K9MoC-00049Z-KE@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K9MoC-00049Z-KE@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

>   > Found a potential security hole while doing that:
>   > static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
>   >                              size_t count, loff_t *data)
>   >     if (copy_from_user(optstr, user, count))
>   >             return -EFAULT;
>   >
>   > is count guaranteed to never be larger than 64?
>  is fixed below.

applied to tip/x86/uv, thanks Cliff.

>  It adds tlb_uv.o to the Makefile.

hm, it was already there in tip/master, so i left this bit out.

>  	char optstr[64];
>  
> +	if (count > 64)
> +		return -EINVAL;

also, this should not be in /proc, but be moved to debugfs. See 
arch/x86/mm/dump_pagetables.c about how to interface to debugfs.

And the "64" value should become something like:

	static const int max_option_len = 64;

or so.

	Ingo
