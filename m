Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYFSPMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYFSPMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYFSPMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:12:44 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62329 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752961AbYFSPMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:12:43 -0400
Date: Thu, 19 Jun 2008 16:10:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let MPS support selectable
In-Reply-To: <200806190018.45944.yhlu.kernel@gmail.com>
Message-ID: <Pine.LNX.4.55.0806191600290.12929@cliff.in.clinika.pl>
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200806181432.57204.yhlu.kernel@gmail.com> <200806181729.31464.yhlu.kernel@gmail.com>
 <200806190018.45944.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Yinghai Lu wrote:

> @@ -233,6 +233,19 @@ config SMP
>  
>  	  If you don't know what to do here, say N.
>  
> +config X86_FIND_SMP_CONFIG
> +	def_bool y
> +	depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
> +	depends on X86_32
> +
> +config X86_MPPARSE
> +	def_bool y
> +	bool "Enable MPS table"
> +	depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
> +	help
> +	  For old smp systems that do not have proper acpi support. Newer systems
> +	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
> +
>  choice
>  	prompt "Subarchitecture Type"
>  	default X86_PC

 First of all you want to make sure at least one of ACPI and X86_MPPARSE
is enabled if X86_LOCAL_APIC or you risk a known-broken kernel
configuration, e.g. SMP which has no slightest chance to work.

 Personally I'd be happy to see CONFIG_ACPI_BOOT we used to have at one
point back just so that you can use ACPI tables to run an SMP system
without the need to pull all the power management stuff.  Useful if the MP
table is broken beyond recovery.  I am assuming it has been removed for a
reason though.

  Maciej
