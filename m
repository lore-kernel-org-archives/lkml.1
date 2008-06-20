Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbYFTGac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbYFTGac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYFTGaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:30:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYFTGaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:30:22 -0400
Date: Fri, 20 Jun 2008 08:29:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH] x86: make 64bit identify_cpu use cpu_dev v2
Message-ID: <20080620062958.GA31182@elte.hu>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806191530.32354.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806191530.32354.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> v2: fix early_panic on some conf
>     reason : struct cpu_vendor_dev size is 16, need to make table to be 16
>              byte alignment
>     also print out the cpu supported...

applied to tip/x86/cpu, thanks Yinghai.

> --- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
> +++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
> @@ -168,6 +168,7 @@ SECTIONS
>  	*(.con_initcall.init)
>    }
>    __con_initcall_end = .;
> +  . = ALIGN(16);
>    __x86cpuvendor_start = .;
>    .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
>  	*(.x86cpuvendor.init)

ah, nice one!

we broke that via v2.6.25-37-g03ae576 "x86: use ELF section to list CPU 
vendor specific code" - should we backport your fix to mainline right 
now? I'm wondering why it only triggered now - did alignment change in 
this section due to your changes and thus this dormant bug became 
triggerable?

	Ingo
