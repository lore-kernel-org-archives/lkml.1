Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZEOWIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZEOWIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZEOWI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:08:27 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35395 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZEOWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:08:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: update_mptable need pci_routeirq
Date: Fri, 15 May 2009 16:08:24 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <4A0DC7DC.7000204@kernel.org> <200905151552.53139.bjorn.helgaas@hp.com> <4A0DE6C5.6060903@kernel.org>
In-Reply-To: <4A0DE6C5.6060903@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151608.25250.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009 04:03:49 pm Yinghai Lu wrote:
> Bjorn Helgaas wrote:
> > On Friday 15 May 2009 03:13:20 pm Yinghai Lu wrote:
> >> Bjorn Helgaas wrote:
> >>> On Friday 15 May 2009 01:51:56 pm Yinghai Lu wrote:
> >>>> to get all device irq routing and save them
> >>> This changelog isn't really enough for me to understand
> >>> what's going on.
> >>>
> >>>> Index: linux-2.6/arch/x86/kernel/mpparse.c
> >>>> ===================================================================
> >>>> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> >>>> +++ linux-2.6/arch/x86/kernel/mpparse.c
> >>>> @@ -17,6 +17,7 @@
> >>>>  #include <linux/acpi.h>
> >>>>  #include <linux/module.h>
> >>>>  #include <linux/smp.h>
> >>>> +#include <linux/pci.h>
> >>>>  
> >>>>  #include <asm/mtrr.h>
> >>>>  #include <asm/mpspec.h>
> >>>> @@ -961,6 +962,7 @@ static int __initdata enable_update_mpta
> >>>>  static int __init update_mptable_setup(char *str)
> >>>>  {
> >>>>  	enable_update_mptable = 1;
> >>>> +	pci_routeirq = 1;
> >>> I hate to see new uses of pci_routeirq.  It'd be nice to remove it
> >>> completely someday.  But maybe it can't be helped.
> >>>
> >>>>  	return 0;
> >>>>  }
> >>>>  early_param("update_mptable", update_mptable_setup);
> >>> "update_mptable" is apparently a boot option, but it's not mentioned
> >>> in Documentation/kernel-parameters.txt.  Is this some sort of debug
> >>> code or BIOS-writer's helper?  Same with "alloc_mptable".  Why do
> >>> we have this stuff?
> >>>
> >> 1. kexec path: after acpi kernel and use kexec to load kerenl with mptable support only or acpi=off
> >> 2. help to BIOS engineer to understand how to set mptable and irq routing setup by chipset.
> >>    esp system have several cards and there is bridge in those cards.
> ...
> > Is (1) common enough to worry about?  What OSes don't have ACPI
> > support?  What advantage is there to using "acpi=off"?
> ...
> 
> some one want to disable acpi, because acpid is using 100%...

I'd rather fix the problem with acpid than make it easier to
use "acpi=off".

Bjorn
