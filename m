Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYGJXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYGJXcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYGJXcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:32:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57474 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYGJXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:32:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182239.635284000@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 16:29:59 -0700
In-Reply-To: <20080710182239.635284000@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 11:17:00 -0700")
Message-ID: <m1r6a1fhc8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2085]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 26/26] x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>
> Index: tree-x86/arch/x86/Kconfig
> ===================================================================
> --- tree-x86.orig/arch/x86/Kconfig	2008-07-10 09:51:44.000000000 -0700
> +++ tree-x86/arch/x86/Kconfig	2008-07-10 09:52:43.000000000 -0700
> @@ -1657,6 +1657,14 @@
>  	 workaround will setup a 1:1 mapping for the first
>  	 16M to make floppy (an ISA device) work.
>  
> +config INTR_REMAP
> +	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
> +	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
> +	help
> +	 Supports Interrupt remapping for IO-APIC and MSI devices.
> +	 To use x2apic mode in the CPU's which support x2APIC enhancements or
> +	 to support platforms with CPU's having > 8 bit APIC ID, say Y.
> +

This has got to be the strangest config option.
X86_IO_APIC makes sense.  Fundamentally it is the wrong config option but that
isn't the fault of your code.

PCI_MSI should not matter.

Is it possible to run in x2apic mode without running in interrupt remapping mode?
Just send the irqs directly to the cpu?  It feels like it should be if an iommu
doesn't get in the way.

Eric
