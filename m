Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYJ3KwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYJ3KwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYJ3Kv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:51:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYJ3Kv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:51:58 -0400
Date: Thu, 30 Oct 2008 11:51:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify X86_MPPARSE config option
Message-ID: <20081030105146.GG3569@elte.hu>
References: <49099CB0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49099CB0.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/Kconfig |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> --- linux-2.6.28-rc2/arch/x86/Kconfig	2008-10-30 11:03:18.000000000 +0100
> +++ 2.6.28-rc2-x86-kconfig-cleanup/arch/x86/Kconfig	2008-10-21 13:57:07.000000000 +0200
> @@ -235,21 +235,13 @@ config X86_FIND_SMP_CONFIG
>  	def_bool y
>  	depends on X86_MPPARSE || X86_VOYAGER
>  
> -if ACPI
>  config X86_MPPARSE
> -	def_bool y
> -	bool "Enable MPS table"
> +	bool "Enable MPS table" if ACPI
> +	default y
>  	depends on X86_LOCAL_APIC
>  	help
>  	  For old smp systems that do not have proper acpi support. Newer systems
>  	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
> -endif
> -
> -if !ACPI
> -config X86_MPPARSE
> -	def_bool y
> -	depends on X86_LOCAL_APIC
> -endif

hm, that's not an equivalent change. But i guess we can do this, it 
sure looks like a cleaner construct.

	Ingo
