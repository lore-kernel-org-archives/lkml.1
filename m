Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZEOVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZEOVxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZEOVxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:53:03 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3441 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbZEOVxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:53:01 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: update_mptable need pci_routeirq
Date: Fri, 15 May 2009 15:52:51 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <4A0DC7DC.7000204@kernel.org> <200905151507.29083.bjorn.helgaas@hp.com> <4A0DDAF0.7080005@kernel.org>
In-Reply-To: <4A0DDAF0.7080005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151552.53139.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009 03:13:20 pm Yinghai Lu wrote:
> Bjorn Helgaas wrote:
> > On Friday 15 May 2009 01:51:56 pm Yinghai Lu wrote:
> >> to get all device irq routing and save them
> > 
> > This changelog isn't really enough for me to understand
> > what's going on.
> > 
> >> Index: linux-2.6/arch/x86/kernel/mpparse.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> >> +++ linux-2.6/arch/x86/kernel/mpparse.c
> >> @@ -17,6 +17,7 @@
> >>  #include <linux/acpi.h>
> >>  #include <linux/module.h>
> >>  #include <linux/smp.h>
> >> +#include <linux/pci.h>
> >>  
> >>  #include <asm/mtrr.h>
> >>  #include <asm/mpspec.h>
> >> @@ -961,6 +962,7 @@ static int __initdata enable_update_mpta
> >>  static int __init update_mptable_setup(char *str)
> >>  {
> >>  	enable_update_mptable = 1;
> >> +	pci_routeirq = 1;
> > 
> > I hate to see new uses of pci_routeirq.  It'd be nice to remove it
> > completely someday.  But maybe it can't be helped.
> > 
> >>  	return 0;
> >>  }
> >>  early_param("update_mptable", update_mptable_setup);
> > 
> > "update_mptable" is apparently a boot option, but it's not mentioned
> > in Documentation/kernel-parameters.txt.  Is this some sort of debug
> > code or BIOS-writer's helper?  Same with "alloc_mptable".  Why do
> > we have this stuff?
> > 
> 
> 1. kexec path: after acpi kernel and use kexec to load kerenl with mptable support only or acpi=off
> 2. help to BIOS engineer to understand how to set mptable and irq routing setup by chipset.
>    esp system have several cards and there is bridge in those cards.

I was sort of hoping for a Documentation/kernel-parameters.txt patch.

Is (1) common enough to worry about?  What OSes don't have ACPI
support?  What advantage is there to using "acpi=off"?

(2) sounds like something that should be under a config option, if
it's in the mainline kernel at all.

Bjorn

