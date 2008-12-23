Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYLWMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYLWMp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYLWMpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:45:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:53269 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750955AbYLWMpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:45:12 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+5Yi4Wrc258ly+4qDQJwz0AQMPzTGl0t1n6vD6T/
	cqihQCk0QwROoO
Date: Tue, 23 Dec 2008 13:45:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <20081223121300.GL9472@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812231327310.5188@axis700.grange>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>
 <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de>
 <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de>
 <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de>
 <20081223121300.GL9472@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Tue, 23 Dec 2008, Robert Schwebel wrote:

> On Tue, Dec 23, 2008 at 11:50:06AM +0100, Sascha Hauer wrote:
> > > You mean an output v4l device? I think overlays are handled by framebuffer 
> > > drivers... But I'm also not quite sure about it, however, handling overlay 
> > > as another framebuffer seems logical to me.
> >
> > Well the DMA engine seems to suggest that frames should be passed around
> > whereas the framebuffer API only has a single frame. That would fit
> > better into the v4l API. Also the IPU can do things like colourspace
> > conversion and hw scaling which would fit into the V4L API.
> 
> Looks like a candidate for gstreamer on the userspace end. Can it be
> decoupled enough to make proper plugins out of it?

I think, the question is rather "can a driver be written for IPU to 
support some sane hardware-neutral image data manipulation API, like v4l?" 
Then you can start writing any user-space apps on top of that API. So, as 
long as there is such an API, I think, we can put it on IPU, yes. My 
problems ATM is - no use-case. What concerns overlay, it is not used in 
the current application, as for image format conversion from the camera - 
I only have a Bayer camera to test with. I even cannot test monochrome 
sanely, because of a lack of a cable:-) And Bayer and monochrome don't 
make good candidates for such conversions - they are not supported by the 
IPU.

> > BTW is the overlay framebuffer useful in it's current implementation?
> > There seems to be no way to adjust the x/y offset or the blending
> > modes.
> 
> The API Eric Miao just posted for the PXA looks sane to me.

I'll have a look, but as I said: -ENOUSER:-)

> > > If there are no other problems with v5, could we maybe take it as a
> > > basis and then I would submit a patch to reduce the number of IRQs?
> >
> > Please understand my concerns with this driver. It's a quite complex
> > beast and experience shows that once a driver is in the kernel it is
> > far more complicated to change it than to do it right the first way.
> 
> Especially when it comes to userspace visible things.
> 
> > You know that I'm also interested in having a MX31 framebuffer (and
> > camera) driver in kernel but I want to make sure that it works
> > properly and leaves room for feature enhancements without having to
> > refactor the whole driver.
> 
> Yup, looks like it would be better to cook it another round instead of
> trying to bring in a half-tested driver with brute-force.

Ok, no problem. Let's just decide

1. is the drivers/dma the final location.
2. do dmaengine maintainers accept it in present form or require any 
   amendments.
3. which interrupts we make visible by default for irq_desc[] and what 
   granularity we want to enable the rest (we could even just make 
   CONFIG_ALL_IPU_IRQS and be 95% sure noone will ever need them.)
4. throw away every trace of overlay support - if anyone ever needs it 
   they should be able to dig it out in ML archives.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
