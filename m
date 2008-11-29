Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYK2TIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYK2TIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYK2TIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:08:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:43850 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751691AbYK2TId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:08:33 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+cXHsIZf+crBjyb7/yLOxAnon30nHiqiuqZ6Bv+Z
	vfBL6gOn4jIwNS
Date: Sat, 29 Nov 2008 20:08:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Laurent Pinchart <laurent.pinchart@skynet.be>, video4linux-list@redhat.com,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 1/3)
In-Reply-To: <200811291519.39549.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0811292002300.8352@axis700.grange>
References: <200811242309.37489.hverkuil@xs4all.nl> <200811251848.09593.hverkuil@xs4all.nl>
 <200811290034.44340.laurent.pinchart@skynet.be> <200811291519.39549.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008, Hans Verkuil wrote:

> > > +Introduction
> > > +------------
> > > +
> > > +The V4L2 drivers tend to be very complex due to the complexity of
> > > the +hardware: most devices have multiple ICs, export multiple
> > > device nodes in +/dev, and create also non-V4L2 devices such as
> > > DVB, ALSA, FB, I2C and input +(IR) devices.
> > > +
> > > +Especially the fact that V4L2 drivers have to setup supporting ICs
> > > to +do audio/video muxing/encoding/decoding makes it more complex
> > > than most. +Usually these ICs are connected to the main bridge
> > > driver through one or +more I2C busses, but other busses can also
> > > be used. Such devices are +called 'sub-devices'.
> >
> > Do you know of other busses being used in (Linux supported) real
> > video hardware, or is it currently theoretical only ?
> 
> The pxa_camera driver is one example of that. Also devices driven by 
> GPIO pins can be implemented this way. I did that in ivtv for example: 
> most cards use i2c audio muxers, but some have audio muxers that are 
> commanded through GPIO so I created a v4l2_subdev that uses GPIO to 
> drive these chips. Works very well indeed.

I think pxa-camera (as well as sh-mobile-ceu and other soc-camera host 
drivers in the works) is not a very good example here. Sensors connected 
to embedded controllers like PXA indeed use a dedicated camera bus but 
only for data exchange. This bus comprises of data and synchronisation 
lines only. Sensors are still connected over an i2c bus for control and 
configuration, also been open to other busses, I haven't seen such 
examples as yet. I might have misunderstood what has been discussed here 
though.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
