Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbXEUQOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbXEUQOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXEUQOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:14:30 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:40713 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754183AbXEUQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:14:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Mon, 21 May 2007 09:14:22 -0700
User-Agent: KMail/1.9.6
Cc: "Jon Smirl" <jonsmirl@gmail.net>, "Jesse Barnes" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <200705210809.25206.jbarnes@virtuousgeek.org> <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
In-Reply-To: <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210914.22663.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Jon Smirl wrote:
> On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Sunday, May 20, 2007, Jon Smirl wrote:
> > > On 5/20/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > With the interfaces implemented here, a userspace application can
> > > > create a multiseat environment either with a single graphics card
> > > > with multiple outputs or multiple cards.  It could do this by
> > > > creating several frame buffer objects and associating them with
> > > > whatever CRTCs were available, and managing input via existing
> > > > APIs.  I don't know of anyone that's done this yet though...
> > >
> > > This design still requires a global server app since the heads share
> > > a single device.
> > > I am always concerned that the root priv code in the X server is a
> > > potential security hole. I would like to move away from a model
> > > where there is a global controlling app. I don't think we need a
> > > global controlling app at all.
> >
> > Even without a graphics server of some sort arbitrating access (and it
> > doesn't have to be a big as the current X server btw), you'd still
> > need your apps to take a card specific lock and/or coordinate so that
> > they don't clobber one another's rendering results.  This could be
> > done in the kernel, but for many devices the complexity added is
> > likely to be pretty high.
>
> We have already have the card specific locks, it's how Direct Rendering
> works.
>
> Besides, card locks are a much better design that the free for all
> that happens on a VT switch.

Right, I'm just saying there's much more to it than just having the 
hardware locks (which of course we already have).

> There is more to fbdev than mode setting. It is also how non-x86
> platforms achieve their boot display. How will boot display be handled
> with the your design? What about console display on non-x86 platforms?
> Loading both fbdev and the new code puts us right back into the
> multiple driver fight we have today.

Maybe you should take a look at the patches. :)  The code I posted actually 
creates an fb device as a slave of the DRM device, and uses that for the 
boot console.  Once you've booted, you can use the new interfaces to do 
whatever you want with the graphics device... though it doesn't 
create /dev/fb* devices per-CRTC like you seem to want, it's really easy 
to do the equivalent with a small userspace program (though I haven't 
actually tested sharing of buffer objects, it should work).

> If the kernel graphics system is going to get rewritten the rewrite
> needs to address all of the existing problems.

Sure, I have no problem with that, but there are usually lots of ways to 
solve a given problem.

Jesse
