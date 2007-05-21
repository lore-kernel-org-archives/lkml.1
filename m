Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbXEUTU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbXEUTU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXEUTUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:20:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:7522 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbXEUTUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y512h6SJj//WPK5MlhMoMHCENr7MyaKRjrAWohM57q5W8yA+QsWtFehNYHY/8hLCfTIxIv0oPSurKQJU3AZ1NrTZDyPf/d3vU5AiR2euoOxJHeQfpQuaRRj5lWy3fDkXZNtrgMEwbyFOFjg8YWNppQXzCsrF/cKMaWmLCynoIis=
Message-ID: <21d7e9970705211220j16a0cf0p8f2bb56369441d9a@mail.gmail.com>
Date: Mon, 21 May 2007 20:20:46 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "Luc Verhaegen" <libv@skynet.be>
In-Reply-To: <9e4733910705211210h7b993da8g67d31a010eb4c3f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
	 <21d7e9970705211047n2328f970ref96ea85856f3ba8@mail.gmail.com>
	 <9e4733910705211104u143e7abercccc4f351441343e@mail.gmail.com>
	 <21d7e9970705211144j219fa8f5n3e5ceab90f7d3f0b@mail.gmail.com>
	 <9e4733910705211210h7b993da8g67d31a010eb4c3f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 5/21/07, Dave Airlie <airlied@gmail.com> wrote:
> > >
> > > You are describing a transition plan without knowing what the final
> > > design is going to look like. We really need to hash out the final
> > > design so that the right path is taken to get there.
> > >
> > > For example I didn't have per CRTC device nodes or user space consoles
> > > in my original design, but after talking to some of the people that
> > > really wanted the multi-seat feature it led me down the user space
> > > console path and to the per CRTC device node solution. I also got beat
> > > up at OLS by people wanting full Unicode support on the console.
> > >
> >
> > No we are defining steps towards improving the drivers on Linux, the
> > first step is the requirement to fix suspend/resume, and allow
> > modesetting on multiple crtc/output combinations, the other goals are
> > not directly within the scope of this work, you can take steps to do
> > get where we want, but we don't need to move all drivers at once to
> > get there... we also can't just merge something like that to the
> > kernel...
> >
> > Your old ideas were mostly limited by the fact that you didn't get the
> > crtc/output distinction and persisted with the idea of heads which put
> > policy in the kernel, this was a major failing you never discovered,
> > and I didn't probably look enough at the time, since then Keith
> > Packard has done a lot of work on randr 1.2 to show the path to what
> > we actually wanted.
>
> I thought Luc Verhaegen figured that out not Keith.
>

Luc figured it out then, Keith made it work for things that aren't
unichrome and spent the time getting the interfaces into the X
server..

> Call it whatever you want and I have wasted far too much time arguing
> with you and Keith and I can never get agreement on anything.  BTW,
> should I search the LKML archives and find the messages where you call
> me stupid and block my patches merging fbdev/DRM? That's effectively
> what you are doing right now.
>

Yup please do, we are doing something seriously different to what you
were trying to do at the time, as we have the experience of the randr
work which demonstrated a path forward rather than trying to strive
for the end...

> There is a significant group of Linux users who want to be able to
> login separate users to each screen/head/crtc/output device. These
> people are concentrated in the third world and don't show up at OLS to
> argue their case.
>
> There is another group that wants Unicode consoles. The people I
> talked to were from India and Japan.
>
> I am not a member of either group. So go ahead and ignore me, I'd just
> like to see these two groups get features implemented that have been
> ignored for a long time.

These people are free to implement these features, we are doing
nothing to block any of these things from happening, but we are not
going to write a userspace console until such time as having a
userspace console becomes useful, whereas we are enabling someone else
to write one on top of the drm now....

We are not going to write a multi-head setup for someone but we are
enabling the setting up of one using the graphics drivers that support
it, we aren't going to enable every driver at once but allow others to
move things over as they like,

The reason this stuff is mainly ending up in the drm is separating the
modesetting from the memory management is definitely not a good plan
and drm has the memory management code now...

We also have VGA arbitration to worry about but again this is
"orthogonal" to the problem space we are currently trying to fix which
is just that we need to suspend/resume GPUs properly and set modes on
multiple output/crtc combos from the kernel.

Dave.
