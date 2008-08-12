Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYHLEZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYHLEZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 00:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYHLEZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 00:25:49 -0400
Received: from mx1.wp.pl ([212.77.101.5]:41638 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYHLEZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 00:25:48 -0400
Date: Tue, 12 Aug 2008 06:31:35 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH RESEND] agp: fix SIS 5591/5592 wrong PCI id
Message-Id: <20080812063135.a8c114ce.krzysztof.h1@wp.pl>
In-Reply-To: <20080811170803.0f3f5df9.akpm@linux-foundation.org>
References: <20080810225452.48ab9fd1.krzysztof.h1@wp.pl>
	<20080811170803.0f3f5df9.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [oUNU]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 17:08:03 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 10 Aug 2008 22:54:52 +0200
> Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
> 
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > 
> > The correct id for the AGP bridge is the id of 
> > the main host (5591) not the id of the PCI-to-PCI
> > bridge AGP (0001). Output from "lspci -nv" shows 
> > that only the former has AGP capabilities flag set:
> > 
> > 00:00.0 0600: 1039:5591 (rev 02)
> >         Flags: bus master, medium devsel, latency 64
> >         Memory at ec000000 (32-bit, non-prefetchable) [size=32M]
> >         Capabilities: [c0] AGP version 1.0
> > 
> > 00:02.0 0604: 1039:0001 (prog-if 00 [Normal decode])
> >         Flags: bus master, fast devsel, latency 0
> >         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> >         I/O behind bridge: 0000c000-0000cfff
> >         Memory behind bridge: eb500000-eb5fffff
> >         Prefetchable memory behind bridge: eb300000-eb3fffff
> > 
> > 
> > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> > ---
> > 
> > The AGP bridge is correctly detected with the patch applied.
> > I have tested it on PC Chips M570 motherboard.
> > 
> > --- linux-mm/drivers/char/agp/sis-agp.c~	2008-08-04 18:00:31.133979040 +0200
> > +++ linux-mm/drivers/char/agp/sis-agp.c	2008-08-06 18:33:02.162916563 +0200
> > @@ -241,7 +241,7 @@ static struct pci_device_id agp_sis_pci_
> >  		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
> >  		.class_mask	= ~0,
> >  		.vendor		= PCI_VENDOR_ID_SI,
> > -		.device		= PCI_DEVICE_ID_SI_5591_AGP,
> > +		.device		= PCI_DEVICE_ID_SI_5591,
> >  		.subvendor	= PCI_ANY_ID,
> >  		.subdevice	= PCI_ANY_ID,
> >  	},
> 
> This fix appears to be applicable to both 2.6.25.x and to 2.6.26.x.  Do you
> think that the problem which it solves is sufficiently serious to
> warrant the backport?
> 

This is old chipset and the error is since kernel 2.6.8 when the
untested support was introduced. I would skip stable branches
as I used it only few days for now. In fact, it is like adding new
hardware which was previously not supported.

Regards,
Krzysztof
