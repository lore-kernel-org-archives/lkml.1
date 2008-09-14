Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYINPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYINPrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYINPrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:47:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56051 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbYINPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:47:23 -0400
Date: Sun, 14 Sep 2008 17:46:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>, Mike Travis <travis@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 2/4] introduce dynamically allocated system vectors
Message-ID: <20080914154659.GN29290@elte.hu>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080911152732.GC13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152732.GC13655@sgi.com>
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


* Dean Nelson <dcn@sgi.com> wrote:

> @@ -1219,42 +1246,40 @@ static int __assign_irq_vector(int irq, 
>  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
>  	 */
>  	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
> -	unsigned int old_vector;
> +	cpumask_t target_cpus_mask;

hm. One SGI developer (Mike Travis) is busy removing on-kernel-stack 
cpumask_t variables. Other one (you) is busy reintroducing them:

> +	cpumask_t target_cpus_mask;
> +	cpumask_t domain;
> +	cpumask_t new_domain_mask = CPU_MASK_NONE;

in multiple ...

> +	cpumask_t mask = TARGET_CPUS;

... functions.

	Ingo
