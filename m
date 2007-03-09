Return-Path: <linux-kernel-owner+w=401wt.eu-S1767344AbXCIQKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767344AbXCIQKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767345AbXCIQKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:10:54 -0500
Received: from yvrmail01.intrinsyc.com ([209.139.192.246]:24155 "EHLO
	yvrmail01.intrinsyc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767344AbXCIQKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:10:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: RE: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Date: Fri, 9 Mar 2007 08:10:56 -0800
Message-ID: <DBC923D919FAB345973A94E6E194E849043808E0@yvrmail01.itc.intrinsyc.com>
In-Reply-To: <20070309153456.GA28664@srcf.ucam.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Thread-Index: AcdiYJWh+IyBoGirQLqgvDy76EolswAA8xgQ
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz> <20070309153456.GA28664@srcf.ucam.org>
From: "Andrew Johnson" <ajohnson@intrinsyc.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Pavel Machek" <pavel@ucw.cz>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote: 
> On Fri, Mar 09, 2007 at 10:08:05AM +0100, Pavel Machek wrote:
> 
> > So... if current console is graphical, we leave X accessing the
> > console... That's bad, because video state is not going to be
> > restored...?
> 
> A graphical console is not necessarily X. Is there any requirement for
> there to be a single VT that isn't in text mode? The vt switching is
> a hack, we shouldn't make life difficult for people who have their own
> userspace code that's entirely capable of restoring video state on its
> own.

The problem actually comes about when using Qtopia Phone Edition (QPE)
on a PXA270. QPE puts the console into VT_AUTO+KD_GRAPHICS mode and
writes directly to the framebuffer from then on.  In this mode the
kernel correctly disallows a console change, as QPE is not getting
notification of a console change and thus does not know when to repaint
the screen. 

AFAIK, X uses VT_PROCESS+KD_GRAPHICS mode, so it gets notification of a
change to and from the X console, thus it knows when to repaint the
screen.

I think you can test this by changing the mode of a text console to
KD_GRAPHICS using the KDSETMODE ioctl, then attempting to change to
another text console using chvt.

-- Andrew
