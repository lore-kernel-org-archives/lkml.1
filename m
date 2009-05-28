Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZE1BLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZE1BLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760113AbZE1BLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:11:00 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:11140 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760100AbZE1BK6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:10:58 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 21:10:58 EDT
X-BigFish: VPS-33(zz542N1432R98dR1805M9371Pzz1202hzzz2dh17dh6bh95n61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC] [PATCH] Device Tree on ARM platform
Date: Wed, 27 May 2009 17:55:50 -0700
In-Reply-To: <20090527162000.GM6805@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] [PATCH] Device Tree on ARM platform
Thread-Index: Acne5wekjjJr3G+BQBeYl5xM3fPAbgANbDiw
References: <1243408083.13460.14.camel@debian-nb><fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com><ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com><20090527150527.GK6805@pengutronix.de><fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <20090527162000.GM6805@pengutronix.de>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>, <grant.likely@secretlab.ca>
CC: "devicetree-discuss" <devicetree-discuss@ozlabs.org>,
       <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Janboe Ye" <yuan-bo.ye@motorola.com>,
       "Timur Tabi" <timur@freescale.com>, <rmk@arm.linux.org.uk>
X-OriginalArrivalTime: 28 May 2009 00:55:51.0100 (UTC) FILETIME=[0BC9C7C0:01C9DF2F]
Message-ID: <20090528005552.839411C88046@mail94-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From:
devicetree-discuss-bounces+stephen.neuendorffer=xilinx.com@ozlabs.org
[mailto:devicetree-
> discuss-bounces+stephen.neuendorffer=xilinx.com@ozlabs.org] On Behalf
Of Robert Schwebel
> Sent: Wednesday, May 27, 2009 9:20 AM
> To: grant.likely@secretlab.ca
> Cc: devicetree-discuss; linux-kernel@vger.kernel.org;
linux-arm-kernel@lists.arm.linux.org.uk; Janboe
> Ye; Timur Tabi; rmk@arm.linux.org.uk
> Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
> 
> Hi Grant,
> 
> On Wed, May 27, 2009 at 09:39:21AM -0600, Grant Likely wrote:
> > This is a MPC5200 is the posterchild for device tree wreckage;
mostly
> > because of my own inexperience at the time.  A lot of mistakes were
> > made and I freely admit that.
> >
> > However, my counter example is Xilinx Virtex support. The Virtex is
an
> > FPGA with all the devices instantiated in the FPGA fabric. It would
> > be a nightmare to try and describe each different FPGA bitstream
using
> > hand coded platform devices, and the xparameters.h file exported by
> > the Xilinx toolchain wasn't much better. Encoding the machine layout
> > in a data structure (the device tree) has decoupled FPGA changes
from
> > the kernel image. Now FPGA engineers can make major changes to FPGA
> > layouts without having to lockstep with changes in the kernel. I
> > regularly boot a single kernel image on multiple bitstream images.
> >
> > That being said, the problems we have had are the reason why it is
> > *not* recommended to hard link the device tree image into firmware.
> > We do commit to not breaking old trees, but the ability to update is
> > important; particularly for enabling new features/drivers.
> 
> Point taken.
> 
> We often have the situation that we have
> 
> - a SoC cpu from vendor A
> - a module with the cpu+ram+peripherals from vendor B
> - a baseboard from vendor C
> - sometimes an extension board from vendor D

I completely agree...  Generally speaking, this is a huge problem for
Microblaze/Virtex PPC support, since very little about the board
connectivity is implied or required based on the chip itself.
Hence, describing the board-level connectivity becomes imperative.  More
importantly, describing the
board-level connectivity separately from the FPGA internal connectivity
is also important from
an information management perspective.
 
> All that with non-introspectable busses, like chip select busses, SPI,
> i2c, FPGA-internal busses etc. We recently tried to put oftree
sniplets
> into the devices (one into the module, one in the baseboard etc), let
> u-boot collect these sniplets and build an oftree out of it. It
doesn't
> work. If you try this, you'll quickly find out that you would have to
> put the schematics into the oftree.

If this is what is required to describe the connectivity of the system,
so be it.
Unfortunately, the fact that OF/DTS has tree structure doesn't provide
syntactic help for making these associations, but neither does it
provide a hinderance either.  At this level, OF/DTS
mainly provides a way of expressing hierarchy, and all the connections
must be specified orthogonally
from the tree hierarchy.

> A peripheral pin can be routed to a
> ball, goes from a connector of the module to a baseboard, to the
> extension board, come back and go to another unit on the SoC. This
> cannot be described in the oftree.

This I disagree with.  There is nothing preventing you from representing
this in a
device tree, other than figuring out how.

> At one place, you need to *know*
> about the whole hardware that you have and have a single "we have X"
to
> "X's oftree" mapping.

In my opinion, the 'platform support code' often devolves into hardcoded
references that
come from digesting all of this connectivity.  This works until knowing
the connectivity
becomes important.  Audio SOCs and clocks are two cases that have been
brought up in
this discussion.  I would
prefer to bite the bullet, and give the kernel all of the information
and let the driver
figure out what is important.
 
> In the end, having a single "X needs these platform data" kernel
source
> file is much, much cleaner and less error prone than what we currently
> have with the oftree.

I disagree.  It may be the easy way to get most things to work in the
short term, but
based on my experience, it results in information holes, hacks, and
other things that would
be neatly solved by taking the time to describe the system more
completely in the first place.

Steve


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


