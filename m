Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYFINMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYFINMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbYFINLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:11:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbYFINLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:11:51 -0400
Date: Mon, 9 Jun 2008 15:11:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Tim Mann <mann@vmware.com>,
       Zachary Amsden <zach@vmware.com>, Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080609131136.GA27588@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

> --- linux-2.6.orig/arch/x86/kernel/tsc_32.c	2008-05-27 12:28:16.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/tsc_32.c	2008-06-03 17:28:46.000000000 -0700
> @@ -401,6 +401,7 @@
>  void __init tsc_init(void)
>  {
>  	int cpu;
> +	u64 lpj;
>  
>  	if (!cpu_has_tsc || tsc_disabled) {
>  		/* Disable the TSC in case of !cpu_has_tsc */
> @@ -421,6 +422,10 @@
>  		return;
>  	}
>  
> +	lpj = ((u64)cpu_khz * 1000);
> +	do_div(lpj, HZ);
> +	lpj_tsc = lpj;

that wont work very well as lpj_tsc is not declared.

	Ingo
