Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbXGYNl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbXGYNl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXGYNlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:41:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54995 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXGYNlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:41:17 -0400
Date: Wed, 25 Jul 2007 15:38:39 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070725153839.353b0153@frecb000686.frec.bull.fr>
In-Reply-To: <20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<200707240948.45916.bjorn.helgaas@hp.com>
	<20070725094554.55c46d8b@frecb000686.frec.bull.fr>
	<200707250716.44609.bjorn.helgaas@hp.com>
	<20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/07/2007 15:45:53,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/07/2007 15:45:55,
	Serialize complete at 25/07/2007 15:45:55
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 15:32:53 +0200 Sébastien Dugué <sebastien.dugue@bull.net> wrote:

> 
>   Hi Bjorn,
> 
> On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Wednesday 25 July 2007 01:45:54 am Sébastien Dugué wrote:
> > >   looks like the commit was dropped, nevertheless here is some more info
> > > to try and understand what may be going on so it may benefit the posterity ;-)
> > 
> > Thank you very much.
> > 
> > Your machine does indeed describe both UARTs in ACPI, and the PNP probe
> > finds them correctly.  The only wrinkle is that the PNP probe names the
> > ports in the order they appear in the ACPI namespace, and your firmware
> > has them "backwards":
> > 
> >                     Device (COMB)
> >                     {
> >                         Name (_HID, EisaId ("PNP0501"))
> >                         Name (_DDN, "COM2")
> >                         Name (_UID, 0x02)
> > 
> >                     Device (COMA)
> >                     {
> >                         Name (_HID, EisaId ("PNP0501"))
> >                         Name (_DDN, "COM1")
> >                         Name (_UID, 0x01)
> 
> 
>   Yes, that's what I thought was weird in the DSDT, but thought the PnP layer
> would map those devices according to UID or at least DDN. It seems that's
> not the case.
> 
> > 
> > There's nothing illegal about this, but with the current PNPACPI,
> > it causes the names to be reversed.  The blind probe tries 0x3f8
> > first, and names that ttyS0.  But the PNP probe, using the namespace
> > order, finds the "COM2" port at 0x2f8 first:
> > 
> >   00:0b: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
> >   00:0c: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
> 
>   Oh I see, didn't notice this though.
> 
> > 
> > So I think your serial console would work without "legacy_serial.force"
> > if you used "console=ttyS1" instead of "console=ttyS0".  But you
> > shouldn't have to do that, of course.
> 
>   Will try ttyS1 just to confirm...
> 
>   Waiting for reboot...
> 
>   OK boots fine with the serial console fully operational again.

  But I also need to change my inittab. At least it confirms the
root cause of the problem.

  Sébastien.
