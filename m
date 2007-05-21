Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbXEURFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbXEURFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbXEURFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:05:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:42095 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbXEURFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r6PochKqmv36F5PsPVKOyL3mYYY5ZPzGLpvGO10jSgMo3uw4Y2PlcOcC3QuCeh9l2ev3LQxilGJBPkPsmMz3INP+sjpsJpuJq8mEH7szmG2JInWIIVz3n3/DAsRnc8sx5wcVrWqyARWy+yD5Fjd/uJhlh22FR4aFYRua2+8KeaY=
Message-ID: <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
Date: Mon, 21 May 2007 13:05:22 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705210934.58559.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Monday, May 21, 2007, Jesse Barnes wrote:
> > > There is more to fbdev than mode setting. It is also how non-x86
> > > platforms achieve their boot display. How will boot display be handled
> > > with the your design? What about console display on non-x86 platforms?
> > > Loading both fbdev and the new code puts us right back into the
> > > multiple driver fight we have today.
> >
> > Maybe you should take a look at the patches. :)  The code I posted
> > actually creates an fb device as a slave of the DRM device, and uses
> > that for the boot console.  Once you've booted, you can use the new
> > interfaces to do whatever you want with the graphics device... though it
> > doesn't create /dev/fb* devices per-CRTC like you seem to want, it's
> > really easy to do the equivalent with a small userspace program (though
> > I haven't actually tested sharing of buffer objects, it should work).
>
> Actually, scratch that last bit.  I forgot about a recent change alanh
> committed that did just that:  per-CRTC FB devices.  So please take a
> close look (modesetting-101 of mesa/drm git at freedesktop.org) and let me
> know if you see any gaping holes.

Here are some of the goals that I believe a rewrite of the graphics
system should address:

1) Be upwards compatible with the existing fbdev drivers. This lets us
avoid rewriting the 90 existing drivers. New drivers shouldn't break
any old apps.

2) Address the long outstanding issue of multi-seat at the console
level. My solution to this is the one device per CRTC model.

3) Eliminate the need for a root priv controlling process. Get rid of
the potential for a security hole.

4) OOPS should always display even if in a graphics mode

5) Support Secure Attention Key (SAK).

6) Eliminate the existing VT swap driver free for all. I would compile
out the VT layer and replace it with a compatible API that enforces
some sanity.

7) Support Unicode on the console

8) Allow multiple user space graphics systems to run. These user space
systems should not touch the hardware, instead they ask the kernel
driver to manipulate the hardware on their behalf. Of course the
kernel driver is only the minimum code needed to arbitrate control of
the resources - it doesn't do things like implement drawing
algorithms.

9) Booting on non-VGA hardware still needs to work.

10) Support things like cloning and output device selection.

Of course a driver doesn't need to support all of this in its first
release. What's important is that the new architecture support all of
these features so that we don't end up rearchitecting it yet again.

Other people may add more things to this list. Let's get the design
right this time around and address all of the known problems.

-- 
Jon Smirl
jonsmirl@gmail.com
