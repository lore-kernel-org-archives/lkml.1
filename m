Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYLDH6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYLDH6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYLDH6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:58:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59607 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYLDH6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:58:07 -0500
Date: Thu, 4 Dec 2008 08:57:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Joakim.Tjernlund@transmode.se
Subject: Re: [PATCH] Allow times and time system calls to return small
	negative values
Message-ID: <20081204075751.GA32594@elte.hu>
References: <18743.25968.602602.875295@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18743.25968.602602.875295@drongo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> @@ -229,6 +230,7 @@ asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
>  		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
>  			return -EFAULT;
>  	}
> +	force_successful_syscall_return();
>  	return compat_jiffies_to_clock_t(jiffies);

just curious: what code does force_successful_syscall_return() actually 
run in the powerpc case - those bits are missing from this patch. I 
suspect it sets some sort of flag?

	Ingo
