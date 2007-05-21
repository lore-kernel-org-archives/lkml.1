Return-Path: <linux-kernel-owner+w=401wt.eu-S1764870AbXEUSEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764870AbXEUSEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbXEUSEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:04:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:5770 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbXEUSEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D4XqrZoh5Jxmr37l2gVvVgC5JEkvRwdSa6ETNIRFRXwTAdbJ9SO9VSrPpEpbW/FpchpvUt+0A6UNOE6xuW16mB6HkHdKCBhIGPJpqMLHdXLWyh4agp+jYcY7fOWs/44/bLNTBEGp2k3sp5v4zAlMusu+6tU+T4g6UpJv+lAjKQI=
Message-ID: <9e4733910705211104u143e7abercccc4f351441343e@mail.gmail.com>
Date: Mon, 21 May 2007 14:04:45 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <21d7e9970705211047n2328f970ref96ea85856f3ba8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
	 <21d7e9970705211047n2328f970ref96ea85856f3ba8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Dave Airlie <airlied@gmail.com> wrote:
> On 5/21/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> > On 5/21/07, Dave Airlie <airlied@gmail.com> wrote:
> > > This just needs a userspace console again a parallel problem that
> > > really isn't much to do with the problem set this work is trying to
> > > solve... it should enable it...
> >
> > When I went through the design process for all this I came to the same
> > conclusion about needing a user space console process.
> >
> > User space console does impact on all of this because it implies that
> > the current console should be be defeatured down until it becomes only
> > a system recovery console and not a console for everyday use.
> >
> > For example, one part of the defeaturing would be to remove the
> > drawing acceleration code in the existing fbdev console drivers and to
> > rework it to support accelerated drawing from the user space console
> > implementation. You want the system recovery console mode to be as
> > simple as possible so that it is always guaranteed to work. User space
> > console is also what leads to the idea of compiling VT out of the
> > kernel.
> >
> > Once you decide that a user space console is needed then the per CRTC
> > device node becomes more obvious since different people can be logged
> > onto the different consoles.
> >
> > All of the points in the list are interrelated and the architecture
> > needs to address everything as a unified whole.
>
> you were doing fine up until the last point, they are interrelated but
> not architecturally dependent, we can do a lot of work on this stuff
> without that, we don't need to deprecate anything, just provide new
> interfaces that new drivers can use to implement this stuff, then
> people can pull over the old drivers at their own pace, like we can
> just stick a flag in the console that says we can handle things like
> dumping oopsen in KD_GRAPHICS etc.. drivers that can do it will do it,
> drivers that can't won't.

You are describing a transition plan without knowing what the final
design is going to look like. We really need to hash out the final
design so that the right path is taken to get there.

For example I didn't have per CRTC device nodes or user space consoles
in my original design, but after talking to some of the people that
really wanted the multi-seat feature it led me down the user space
console path and to the per CRTC device node solution. I also got beat
up at OLS by people wanting full Unicode support on the console.

>
> You don't compile VT out you just disable it when you have a driver
> that supports the model,
>
> You also require a heavy weight state switch for suspend/resume in any
> case so this could be utilised for other things, e.g. text mode on
> many cards can't be done while acceleration is operational, but
> certainly don't want to bar text mode for people who want it..
>
> Dave.
>


-- 
Jon Smirl
jonsmirl@gmail.com
