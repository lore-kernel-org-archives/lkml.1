Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZHMGqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZHMGqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZHMGqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:46:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZHMGqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:46:53 -0400
Date: Thu, 13 Aug 2009 08:46:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
Message-ID: <20090813064634.GA12143@elte.hu>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang, Shane <shane.wang@intel.com> wrote:

> Signed-off-by: Shane Wang <shane.wang@intel.com>
> 
> diff -r 7358cf1b3090 arch/x86/kernel/tboot.c
> --- a/arch/x86/kernel/tboot.c   Wed Aug 12 03:04:23 2009 -0700
> +++ b/arch/x86/kernel/tboot.c   Wed Aug 12 18:06:21 2009 -0700
> @@ -169,6 +169,7 @@ void tboot_create_trampoline(void)
> 
>  static void set_mac_regions(void)
>  {
> +#ifdef CONFIG_ACPI_SLEEP
>         tboot->num_mac_regions = 3;
>         /* S3 resume code */
>         tboot->mac_regions[0].start = PFN_PHYS(PFN_DOWN(acpi_wakeup_address));
> @@ -181,6 +182,7 @@ static void set_mac_regions(void)
>         tboot->mac_regions[2].start = PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
>         tboot->mac_regions[2].size = PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
>                                      PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> +#endif

These #ifdefs are quite ugly. Why not add a 'depends on ACPI_SLEEP' 
rule to the INTEL_TXT Kconfig section?

Also, instead of:

+       depends on EXPERIMENTAL && X86 && DMAR && ACPI

Please change the X86 to HAVE_INTEL_TXT, provide that Kconfig option 
(non-interactive) and select HAVE_INTEL_TXT from arch/x86/Kconfig, 
via a line like this:

	select HAVE_INTEL_TXT if DMAR && ACPI_SLEEP

Thanks,

	Ingo
