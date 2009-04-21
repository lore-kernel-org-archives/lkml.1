Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbZDUHBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbZDUHBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDUHBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:01:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZDUHBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:01:22 -0400
Date: Tue, 21 Apr 2009 09:01:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, Weidong Han <weidong.han@intel.com>
Subject: Re: [patch 3/5] x2apic, IR: cleanup panic() with nox2apic boot
	option
Message-ID: <20090421070101.GB22937@elte.hu>
References: <20090420200450.128993000@linux-os.sc.intel.com> <20090420200450.425091000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420200450.425091000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Instead of panic() ignore the "nox2apic" boot option when BIOS has
> already enabled x2apic prior to OS handover.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Weidong Han <weidong.han@intel.com>
> ---
> 
> Index: tip/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/apic.c
> +++ tip/arch/x86/kernel/apic/apic.c
> @@ -142,8 +142,12 @@ static int x2apic_preenabled;
>  static int disable_x2apic;
>  static __init int setup_nox2apic(char *str)
>  {
> -	if (x2apic_enabled())
> -		panic("Bios already enabled x2apic, can't enforce nox2apic");
> +	if (x2apic_enabled()) {
> +		pr_warning("Bios already enabled x2apic, "
> +			   "can't enforce nox2apic");

Btw., in such cases we dont break printk strings in the middle but 
ignore the checkpatch warning. I fixed it up in your patch.

The advantage is that if someone, based on a dmesg line, types:

   git grep Bios already enabled x2apic, can't enforce nox2apic

the right source code line will be found. In the broken-up-line case 
this wont work. (grep is fundamentally single-line)

	Ingo
