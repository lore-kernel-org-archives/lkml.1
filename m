Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828Ab0AKVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0AKVtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218Ab0AKVtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:49:16 -0500
Received: from pc-249.acfr.usyd.edu.au ([129.78.210.249]:57887 "EHLO
	rosaceae.acfr.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0AKVtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:49:16 -0500
From: Alex Brooks <a.brooks@marathon-robotics.com>
Organization: Marathon Robotics
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: BAR 0: can't allocate resource
Date: Tue, 12 Jan 2010 08:47:47 +1100
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001061305.31635.a.brooks@marathon-robotics.com> <201001101407.26930.a.brooks@marathon-robotics.com> <201001111427.03777.bjorn.helgaas@hp.com>
In-Reply-To: <201001111427.03777.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001120847.47684.a.brooks@marathon-robotics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > including some new
> > information about an address collision for the recalcitrant device:
> >
> > pci 0000:01:04.0: address space collision: [mem 0x00800000-0x00800fff]
> > already in use
> > pci 0000:01:04.0: can't reserve [mem 0x00800000-0x00800fff]
> >
> > Does this shed any more light on things (or can you tell me what I could
> > modify to get better debug info)?
>
> It shows that we think the octal UART is at 0x00800000, which
> doesn't seem valid (I think it's in the middle of your system RAM).
>
> This is before Linux moves anything around, so normally this would
> be what BIOS left in the BAR.  But BIOS puts it at 0xfebff000 in the
> working case (without the Mini PCI adapter), and the adapter shouldn't
> even be visible to the BIOS, so I would expect the octal UART to still
> be at the same address.
>
> I'm afraid I still don't see a software problem here.  To me (and I'm
> certainly not a hardware person), it feels like an electrical problem
> on the PCI bus: we read a BAR and it has a nonsensical value, we write
> the BAR and can't read that value back, we read the vendor/device/class
> codes and get nonsense.  It's also interesting that most of these
> nonsense values we read seem to have only one bit set.

OK, at this point I think I'll look into switching hardware.  Thanks very much 
for all the help.


Alex
