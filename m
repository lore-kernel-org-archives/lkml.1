Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZJFEok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZJFEok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZJFEoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:44:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:50651 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZJFEoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:44:39 -0400
Date: Tue, 6 Oct 2009 06:44:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: Work around BIOS bugs by quiescing USB controllers earlier" causes MCEs
Message-ID: <20091006044401.GA30316@wotan.suse.de>
References: <20091002073400.GV6327@wotan.suse.de> <19141.54587.207559.849751@pilspetsen.it.uu.se> <19142.21600.475756.10647@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19142.21600.475756.10647@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 09:28:32PM +0200, Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > Nick Piggin writes:
>  >  > Hi,
>  >  > 
>  >  > Your patch db8be50c4307dac2b37305fc59c8dc0f978d09ea is causing my
>  >  > ia64 Altix system to die with an MCE in early boot.
>  > 
>  > The same commit has been confirmed by two people on the ARM list
>  > to cause boot failures on two different Intel XScale IOP machines.
>  > The machines have serial consoles, but only show
>  > 
>  > Uncompressing Linux... done. Booting the kernel.
>  > 
>  > before they hang.
> 
> I've just investigated this on one of my ARM boxes that this commit kills.
> 
> The commit changed quirk_usb_early_handoff to be a FIXUP_HEADER, which
> caused it to be invoked during the early stages of the platform's PCI
> init (arch/arm/kernel/bios32.c). quirk_usb_handoff_uhci() gets a bogus
> I/O base address, passes that down to uhci_reset_hc(), causing a kernel
> page fault in the first "outw(UHCI_USBCMD_HCRESET, base + UHCI_USBCMD);",
> causing the kernel to oops.
> 
> (All this occurs before the serial console works, so I had to add a
> platform-specific puts() and lots of tracing statements.)
> 
> Changing this quirk back to a FIXUP_FINAL allows the platform's PCI
> init to complete. Later on the generic pci_init() calls the quirk,
> which now gets the correct I/O base address, and the outw()s in
> uhci_reset_hc() don't fail.

Thanks for this, I guess we await David's response.
