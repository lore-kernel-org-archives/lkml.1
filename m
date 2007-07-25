Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbXGYM4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbXGYM4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbXGYM4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:56:40 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:48902 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbXGYM4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:56:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Wed, 25 Jul 2007 06:55:07 -0600
User-Agent: KMail/1.9.6
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?iso-8859-1?q?S=E9bastien?= =?iso-8859-1?q?_Dugu=E9?=" 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707242034.42679.bjorn.helgaas@hp.com> <86802c440707242127n17a27a29u6d821044bfba8cf9@mail.gmail.com>
In-Reply-To: <86802c440707242127n17a27a29u6d821044bfba8cf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707250655.07746.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 10:27:26 pm Yinghai Lu wrote:
> On 7/24/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Tuesday 24 July 2007 02:33:05 pm Yinghai Lu wrote:
> > > I have a system that has the same problem, and it turns out that FW
> > > missed PNP0501 is DSDT for uart. and add that it into DSDT works well.
> >
> > Is this FW that has been shipped?  Can you give any more details,
> > like DMI info and a copy of the DSDT?  We can't expect users to
> > upgrade their firmware or use a custom DSDT.
> 
> The system is not shipped yet.
> Normally PNP0501 is coming with superio section in DSDT. So i think
> late BIOS if have acpi there, that should be there already.
> Problem is that some new design may get rid of superio, but SB could
> have extra uart for serial port. at that case BIOS may not have that
> PNP0501...

If the system has a non-PCI UART that is usable by the OS, it
should be described by ACPI.  This is true regardless of whether
the UART is attached via superio or elsewhere.

So in this case, my patch just helped expose a defect in the
firmware, and it sounds like the firmware was fixed before
ever being shipped.

> or we can make legacy_serial.force=1 is default at this point.

At which point?  We already do the legacy probe if there are no
PNP devices.  Do you mean we should also do the legacy probe if
there are PNP devices, but no serial devices were found?  That
might be reasonable to do, but wouldn't have prevented the problem
on Sebastien's machine, because his machine *does* have PNP UARTs.

Bjorn

