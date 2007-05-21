Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXEUQBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXEUQBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXEUQBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:01:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:10781 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbXEUQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BkcX0O86TTTvesN8yy8wWqr1KwwVSDRwLNWg8PvvYPzgGc6+YMqg8SzrtDjDpTwkeVpvhUgGSuEOUH9+vZEHi9lTQk+Y16XjIIhHugRzPkggJGG64xTzciPkHS0hiyV76r/3elfBcqOJCoSZvaLjwA+MPhaJLJvbJdotEqNBlwc=
Message-ID: <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
Date: Mon, 21 May 2007 12:01:30 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jon Smirl" <jonsmirl@gmail.net>, "Jesse Barnes" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705210809.25206.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705201610.32170.jbarnes@virtuousgeek.org>
	 <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
	 <200705210809.25206.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sunday, May 20, 2007, Jon Smirl wrote:
> > On 5/20/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > With the interfaces implemented here, a userspace application can
> > > create a multiseat environment either with a single graphics card with
> > > multiple outputs or multiple cards.  It could do this by creating
> > > several frame buffer objects and associating them with whatever CRTCs
> > > were available, and managing input via existing APIs.  I don't know of
> > > anyone that's done this yet though...
> >
> > This design still requires a global server app since the heads share a
> > single device.
> > I am always concerned that the root priv code in the X server is a
> > potential security hole. I would like to move away from a model where
> > there is a global controlling app. I don't think we need a global
> > controlling app at all.
>
> Even without a graphics server of some sort arbitrating access (and it
> doesn't have to be a big as the current X server btw), you'd still need
> your apps to take a card specific lock and/or coordinate so that they
> don't clobber one another's rendering results.  This could be done in the
> kernel, but for many devices the complexity added is likely to be pretty
> high.

We have already have the card specific locks, it's how Direct Rendering works.

Besides, card locks are a much better design that the free for all
that happens on a VT switch.

> OTOH, if you're just talking about mapping sections of VRAM to user level
> processes to manage as indpendent heads, that's fairly trivial to do as
> you say, but you'd almost certainly want acceleration for any sort of real
> world application, which is where things would get tricky.
>
> > How are you reconciling the introduction of a new mode setting API
> > with the 90 existing fbdev drivers? We clearly don't want two
> > competing APIs in the kernel. What's the plan for converting all of
> > the existing drivers?
>
> My initial plan was to only convert drivers to this new API if they had
> hardware that justified a DRM driver (i.e. high performance devices with
> command ring buffers, 3D, etc.), and leave the other FB drivers alone,
> since the FB layer is quite suited to simple devices.
>
> The other option of course is to port the existing drivers over to the new
> modesetting interfaces, though I suspect in many cases that may not be
> particularly useful.  I'm open to suggestions.

There is more to fbdev than mode setting. It is also how non-x86
platforms achieve their boot display. How will boot display be handled
with the your design? What about console display on non-x86 platforms?
Loading both fbdev and the new code puts us right back into the
multiple driver fight we have today.

If the kernel graphics system is going to get rewritten the rewrite
needs to address all of the existing problems.

-- 
Jon Smirl
jonsmirl@gmail.com
