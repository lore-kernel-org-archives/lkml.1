Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZCSUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZCSUOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbZCSUOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:14:19 -0400
Received: from kroah.org ([198.145.64.141]:35690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753828AbZCSUOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:14:18 -0400
Date: Thu, 19 Mar 2009 13:10:32 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319201032.GA17094@kroah.com>
References: <20090319040809.GA29249@kroah.com> <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 04:48:54PM +1000, Dave Airlie wrote:
> On Thu, Mar 19, 2009 at 2:08 PM, Greg KH <greg@kroah.com> wrote:
> > Hi,
> >
> > Here's 5 patches that add the Intel Poulsbo/Morrestown DRM driver to the
> > kernel tree.
> >
> > There are 4 patches that make changes to the DRM core, and one patch
> > that adds the DRM driver itself.  The driver is added to the
> > drivers/staging/ directory because it is not the "final" driver that
> > Intel wishes to support over time.  The userspace api is going to
> > change, and work is currently underway to hook up properly with the
> > memory management system.
> 
> >
> > However this work is going to take a while, and in the meantime, users
> > want to run Linux on this kind of hardware.  I'd really like to add the
> > driver to the staging tree, but it needs these core DRM changes in order
> > to get it to work properly.
> >
> > Originally I had a patch that basically duplicated the existing DRM
> > core, and embedded it with these changes and the PSB driver together
> > into one big mess of a kernel module.  But Richard convinced me that
> > this wasn't the "nicest" thing to do, and he did work on the PSB code
> > and dug out these older DRM patches.
> >
> > The only thing that looks a bit "odd" to me is the unlocked ioctl patch,
> > Thomas, is that thing really correct?
> >
> > David, I'd be glad to take the DRM changes through the staging tree, but
> > only if you ack them.
> 
> First off, the non-staging patches need more complete changelog entries,
> a bit of meaning goes a long way. I'll ack them if they are documented and
> make sense. The unlocked ioctl hook makes sense to me at least!

Heh, that one doesn't make sense to me as it doesn't seem to change any
locking issues :)

I'll write up better changelog comments based on other responses in this
thread.

> Now the non-core DRM driver comes with some caveats no one mentioned,
> only the userspace 2D is open, no userspace 3D is available and I've no idea if
> one is forthcoming. Now I don't know enough about the Poulsbo to say this
> drm implementation is secure and can't DMA over my password file.
> 
> There is no upstream X.org driver available for this yet, Ubuntu
> shipped something but really we should be at least seeing X.org and
> Mesa commitments from Intel to supporting this code in the future
> before we go shipping it all in the kernel.

The xorg driver is public, as has been pointed out.

As for the legality of the 3d binary blob, I really have no idea, and
for now, I really don't care, I just want basic 2d to work properly on
my hardware.

> Staging something with a very broken userspace API is going to be an nightmare,

That's exactly what staging is for :)

Seriously, stuff in drivers/staging has horrible userspace api issues,
and has no guarantee to work properly at all in future kernel versions.
That's why we are using the staging tree, it lets users have a common
place to get the latest code to get their hardware working, and lets
developers work together in one place.

See my lkml post yesterday about staging if you have other questions
about it.

> So really I'm NAKing this from ever entering the mainline in its
> current form, without a supporting roadmap and plans for the userspace
> bits.

staging isn't really "mainline" so much as it is a place to get things
working.

If you want, I'll respin the drm changes and resubmit them.

If you aren't going to want to accept those drm changes, that's fine,
and I have no problem with that.

In that case, I'll just "embed" a private copy of the drm core in the
psb kernel driver in staging, much like we have done many times already
with wireless drivers.  Yes, it's not the nicest or prettiest thing at
all, but it lets people use their hardware and is a hell of a lot better
than burrying this stuff in random git trees around the world in ways
that no one else can figure out how to get working (like Ubuntu has
already done...)

thanks,

greg k-h
