Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXGYP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXGYP54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761367AbXGYP5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:57:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42824 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764AbXGYP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C/dr73MKkAtt0SMqXeQoZ0s7vosdSAskqoB9kS50lHkAqL4otaNPlOntlXzemaaA8nhxP/i3dW7amDWkrB8lz7vQszv1EZx5Dp7VlGZmMWvx2ALpzBF3guTUX59K+bDKVybs0KZKcvmfJTAN/LIoCGECFYP35G2X+Jt7xdgQEow=
Message-ID: <86802c440707250857u22e5afa3kefb06a997c38c3b8@mail.gmail.com>
Date: Wed, 25 Jul 2007 08:57:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200707250655.07746.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707242034.42679.bjorn.helgaas@hp.com>
	 <86802c440707242127n17a27a29u6d821044bfba8cf9@mail.gmail.com>
	 <200707250655.07746.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Tuesday 24 July 2007 10:27:26 pm Yinghai Lu wrote:
> > On 7/24/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > On Tuesday 24 July 2007 02:33:05 pm Yinghai Lu wrote:
> > > > I have a system that has the same problem, and it turns out that FW
> > > > missed PNP0501 is DSDT for uart. and add that it into DSDT works well.
> > >
> > > Is this FW that has been shipped?  Can you give any more details,
> > > like DMI info and a copy of the DSDT?  We can't expect users to
> > > upgrade their firmware or use a custom DSDT.
> >
> > The system is not shipped yet.
> > Normally PNP0501 is coming with superio section in DSDT. So i think
> > late BIOS if have acpi there, that should be there already.
> > Problem is that some new design may get rid of superio, but SB could
> > have extra uart for serial port. at that case BIOS may not have that
> > PNP0501...
>
> If the system has a non-PCI UART that is usable by the OS, it
> should be described by ACPI.  This is true regardless of whether
> the UART is attached via superio or elsewhere.
>
> So in this case, my patch just helped expose a defect in the
> firmware, and it sounds like the firmware was fixed before
> ever being shipped.

Yeah.

>
> > or we can make legacy_serial.force=1 is default at this point.
>
> At which point?  We already do the legacy probe if there are no
> PNP devices.  Do you mean we should also do the legacy probe if
> there are PNP devices, but no serial devices were found?  That
> might be reasonable to do, but wouldn't have prevented the problem
> on Sebastien's machine, because his machine *does* have PNP UARTs.

but still could have problem. if the system does not have any uart,
and So we can not find that in DSDT...and we add legacy again...that
is not right.

YH
