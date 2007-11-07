Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbXKGNXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbXKGNXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbXKGNXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:23:02 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:51799 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbXKGNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:23:00 -0500
Date: Wed, 7 Nov 2007 13:22:48 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Adam Belay <ambx1@neo.rr.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] [PATCH] PNP: request ioport and iomem resources used by
 active devices
In-Reply-To: <200710291525.31475.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64N.0711071252500.14970@blysk.ds.pg.gda.pl>
References: <200710291525.31475.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Bjorn Helgaas wrote:

>     0000-001f : dma1		<-- built-in resource includes 2 controllers
>       0000-000f : 00:02		<-- PNP reports only one DMA controller
[...]
>     0060-006f : keyboard	<-- built-in resource groups several things
>       0060-0060 : 00:04		<-- PNP reports 8042 controller data register
>       0061-0061 : 00:03		<-- PNP reports AT-style speaker
>       0064-0064 : 00:04		<-- PNP reports 8042 controller status register

 Note that the built-in resources are requested according to how the PC/AT 
architecture defined address decoding for the relevant subsystems.  In 
particular, there was always a single DMA controller at 0x0000 and the 
8042 controller was decoded at 0x0060.  No full decoding was done and 
unused locations aliased to the corresponding ones with the don't-care 
bits set to the other value.  I do not recall all the details of the port 
B (named after the original from the 8255 as used in the PC/XT) at 0x0061 
as implemented in the PC/AT and I do not have a reference handy, but it is 
a bunch of GPIO bits, some being r/o and some r/w, possibly with 
side-effects.  I believe it was a set of additional latches sub-decoded 
from the 8042 controller range for compatibility with how the 8255 was 
wired and programmed.

 Anyway, PNP may provide a more accurate picture of the address ranges in 
a particular system... if it gets it right!  Which is a lost hope, I 
suppose, as even the above is questionable -- "AT-style speaker" is a 
misnomer as most of the GPIO bits involved deal with the handling of 
system error interrupts normally routed to NMI.

 The patch itself is useful and makes sense though.  Have you passed it 
through `scripts/checkpatch.pl'?

  Maciej
