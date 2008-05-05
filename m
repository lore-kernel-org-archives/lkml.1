Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbYEEXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbYEEXdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYEEXdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:33:02 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:27825 "EHLO
	outbound3-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYEEXdA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:33:00 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Date: Mon, 5 May 2008 16:32:36 -0700
In-reply-to: <1210029394.5798.140.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Thread-Index: AcivBjXPpLboL6SxR7+G9xTT+vyRqwAAMo9w
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu> <20080505172535.9710319B8086@mail101-wa4.bigfish.com> <1210029394.5798.140.camel@localhost>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
Cc: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
       <linux-arch@vger.kernel.org>, "John Linn" <linnj@xilinx.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 05 May 2008 23:32:34.0145 (UTC) FILETIME=[4B81B510:01C8AF08]
Message-Id: <20080505233234.59C381488046@mail76-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The .dts is not board specific, it's design specific.  In my opinion,
this is not something that 'a vendor might maintain multiple versions
of': instead it is in most cases simply fundamental to the FPGA design
flow.  In fact, in most cases, I'd like to make the .dts file part of
the bitstream and not compiled into the kernel.

Although powerpc has a bit more boot-time complexity than the microblaze
does currently, I think it makes alot of sense to have some consistency
here, and there is already a pattern to follow here which nicely
orthogonalizes multiple .dts files for the same platform code.

Steve

> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Monday, May 05, 2008 4:17 PM
> To: Stephen Neuendorffer
> Cc: monstr@seznam.cz; linux-kernel@vger.kernel.org; arnd@arndb.de;
linux-arch@vger.kernel.org; John
> Linn; matthew@wil.cx; will.newton@gmail.com; drepper@redhat.com;
microblaze-uclinux@itee.uq.edu.au;
> grant.likely@secretlab.ca; Michal Simek
> Subject: RE: [PATCH 10/56] microblaze_v2: Generic dts file for
platforms
> 
> On Mon, 2008-05-05 at 10:25 -0700, Stephen Neuendorffer wrote:
> > I think it would be nice if dts files were stored in boot/dts, as on
> > powerpc, which would reduce confusion.
> 
> I'm not so sure.  By grouping
> 
>  * the DTS
>  * Kconfig.auto (now just storing CPU parameters for CPUFLAGS); and
>  * board-specific setup.c if required,
> 
> we concentrate in one place, in a single subdir of
> arch/microblaze/platform/*, all of the board specific info.
> 
> Maybe our Kbuild should copy the platform .dts file out of the
platform
> dir and into microblaze/boot, like we do with the finished kernel?
Then
> it's ready to be picked up by the user or some higher level build
tool.
> 
> If users or vendors want to maintain multiple DTS files for a single
> board, again they can just collect them in the platform subdir so
their
> intended target remains obvious.
> 
> John
> 
> 
> >
> > Steve
> >
> > > -----Original Message-----
> > > From: monstr@seznam.cz [mailto:monstr@seznam.cz]
> > > Sent: Sunday, May 04, 2008 4:41 AM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: arnd@arndb.de; linux-arch@vger.kernel.org; Stephen
Neuendorffer;
> > John Linn;
> > > john.williams@petalogix.com; matthew@wil.cx;
will.newton@gmail.com;
> > drepper@redhat.com; microblaze-
> > > uclinux@itee.uq.edu.au; grant.likely@secretlab.ca; Michal Simek
> > > Subject: [PATCH 10/56] microblaze_v2: Generic dts file for
platforms
> > >
> > > From: Michal Simek <monstr@monstr.eu>
> > >
> > >
> > > Signed-off-by: Michal Simek <monstr@monstr.eu>
> > > ---
> > >  arch/microblaze/platform/generic/system.dts |  137
> > +++++++++++++++++++++++++++
> > >  1 files changed, 137 insertions(+), 0 deletions(-)
> > >  create mode 100644 arch/microblaze/platform/generic/system.dts
> >
> --
> John Williams, PhD, B.Eng, B.IT
> PetaLogix - Linux Solutions for a Reconfigurable World
> w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
> 
> 


