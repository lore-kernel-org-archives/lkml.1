Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbZHES3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbZHES3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHES3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:29:40 -0400
Received: from kroah.org ([198.145.64.141]:58893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZHES3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:29:39 -0400
Date: Wed, 5 Aug 2009 11:28:05 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090805182805.GA7534@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 07:20:37PM +0100, Alan Cox wrote:
> On Wed, 5 Aug 2009 10:15:13 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.
> 
> You seem to have reposted it rather than anyone addressing any of the
> complaints people made about ?
> 
> To quote Christoph
> 
> > What tree did you find with devtmpfs in it?  It was pretty clearly
> > rejected when it came up.

That's not anything to address, what do you want me to say, "maple"?  :)

> and Arjan (who is doing about the fastest Linux boot anyone has and has
> better data than anyone else)

We did this work based on Arjan's work.  It solves a problem that Moblin
has as well, which is why Novell is using it for their Moblin-based
images they are shipping.  It makes things go faster, with a simpler
userspace codepath, and we have the numbers as have been previously
posted.

> > so just to state the obvious: this code is not needed to boot fast.
> > It is mostly a workaround for having a bad initrd; if you don't use an
> > initrd, or if you use an initrd that's made with the right device nodes
> > in it already, you really just don't need this.
> 
> > I would much rather that you just fix your initrd... than to put this
> > sort of thing into the kernel....

We have "fixed" our initrd, so much so we don't even use one for Moblin,
just like Intel doesn't.  The userspace boot sequence uses this for a
faster boot time.  Ubuntu and Red Hat both independently confirmed this
as well.

> plus 
> 
> > Eric has shown that just making the nodes is 0.06 seconds with todays
> > sysfs interface, and there is room for improvement,

A 0.06 speedup is still a speedup, right?  :)

Seriously, we saw much more than that, about 0.5 from what I last
remember, Kay?

> and Erik Biederman
> 
> >> option for us. And still, nobody will be forced
> >> to use it, it's entirely optional. For our systems, we decided to do
> >> it that way, and we ship it already in the distro, and if there are no
> >> substantial problems coming up, which we don't expect, we will
> >> continue using it.  
> 
> > Yes but you are asking all of us to maintain it.  Forever in perpetuity.
> > A better case needs to be made than you have already shipped the code.

I will maintain it.  Or Kay will.  It's the equalivant of adding a
driver to the kernel, if you don't want it, it touches nothing else.
The diffstat shows a bit of reorg to handle this, I can split it into 2
patches if that's really necessary.

> Also can you confirm the SELinux issues raised by Stephen Smalley and
> David Quigley were fixed and resolved.

>From what I recall, yes, they were.  I'm guessing the Red Hat boot tests
performed by Harald confirms this.

thanks,

greg k-h
