Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXEVApZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXEVApZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbXEVApN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:45:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:42849 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXEVApM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pgSr+HQBtOXUQkaQ8U2lA+wFLIJ9gvxE4zwoPyrIZJVWCTPAGP456bONj8GTRtSPiA2uob6aA2m0AfkerNVG6IuIjukLkfgRbwP381GTjyvgJtpKsze1lKZcwuPllc8Hor3l98nl2MmrhN4Pf0B0nJdgz3UwVRAapz4bLTTyTvI=
Message-ID: <9e4733910705211745q40de7683xb6ede752b53538ed@mail.gmail.com>
Date: Mon, 21 May 2007 20:45:09 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jeff Garzik" <jeff@garzik.org>, "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <20070522013545.5c269641@the-village.bc.nu>
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
	 <4652295E.7060305@garzik.org>
	 <20070522013545.5c269641@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > the kernel, it can be a lot smaller than X and auditable.. sticking
> > > the DRI protocol in the kernel is just pointless..
> >
> > It is a quite sensible idea.
> >
> > The userspace X server SHOULD be running under a non-root user, with
> > appropriate fine-grained privs granted to it.
> >
> > "I need root to do graphics" is a myopic, antiquated view of the world.
>
> X server: priviledges below everything, pageable
> kernel: priviledges as high as conceivable, non-pageable
>
> So why do you want it in kernel.... security is not the sensible answer
> here.

Have you inspected the multi-megabyte X server for security holes to
the same level the kernel has been inspected?

The only part that needs to be in the kernel driver is the code
controlling locking and code that plays with the hardware. Moving it
into the driver ensures that only the minimal amount of root priv code
possible is going to end up in the system. If someone tries to move
too much into the kernel I'm sure you'll let them know that it's a bad
idea.

The problem right now is that code that needs root priv is all
intertwined with code that doesn't need it and it all ends up getting
run as root.

BTW, when I prototyped this a couple of years ago by merging Radeon
DRM/fbdev I only needed to add about 10K more code to the device
driver. Most of that was associated with getting the VBIOS to run in
x86 mode when the driver was first loaded. That code can be marked
_init. We're not talking about a lot of code needing to go into the
kernel.

-- 
Jon Smirl
jonsmirl@gmail.com
