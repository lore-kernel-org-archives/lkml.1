Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZFWH5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZFWH5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZFWH5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:57:25 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:39409 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756679AbZFWH5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:57:23 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 03:57:23 EDT
Subject: Re: [git pull] drm: previous pull req + 1.
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas@netline-mail2.netline.ch, Dave Airlie <airlied@linux.ie>,
       Andrew Lutomirski <luto@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.sf.net,
       Alex Deucher <alexdeucher@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090622181832.771dac03@jbarnes-g45>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	 <4A3F3E3A.2030202@shipmail.org> <1245715213.4017.13.camel@pasglop>
	 <alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	 <1245719079.4017.25.camel@pasglop>  <20090622181832.771dac03@jbarnes-g45>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Jun 2009 09:48:00 +0200
Message-Id: <1245743280.5580.2203.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 18:18 -0700, Jesse Barnes wrote:
> On Tue, 23 Jun 2009 11:04:39 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Mon, 2009-06-22 at 17:24 -0700, Linus Torvalds wrote:
> > > 
> > > On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
> > > > 
> > > > As far as I can remember, all fbdev operations are done under the
> > > > console semaphore.
> > > 
> > > Yeah, and some of them are horribly broken (ie copying data from
> > > user space while doing it - causing horrible things like VC
> > > switching latencies and invisible printk's if an oops happens
> > > during the op).
> > > 
> > > Or maybe that got fixed. 
> > 
> > Well, it does rely on userspace behaving.. ie, no accel ops are done
> > by the kernel in KD_GRAPHICS and userspace is -supposed- to switch to
> > KD_GRAPHICS before touching the fb.
> > 
> > In fact, nowdays, we do have the infrastructure to be smart and
> > enforce that. IE. Instead of using a boring remap_page_ranges() in
> > fb_mmap() we could use a fault handler. When in KD_TEXT, we fail
> > them, when in KD_GRAPHICS, we service them, and we
> > unmap_mapping_range() when switching. Something like that...
> > 
> > Dunno how that interacts with the new DRM thingy though.
> 
> I think it could work, but ideally we'd keep the kernel fbcon object
> pinned, and keep printing into it even while some other gfx app is
> running.

It doesn't need to be pinned for that, does it? I think in the long run
it's a bad idea to have it pinned all the time, think of machines with
only 8 MB of VRAM...


> (something like this would also be handy for dual head debugging; one
> head running your desktop and the other a debug console printing all
> the messages).

On a side note, I did precisely that about ten years ago on my Amiga. :)
Granted, that was using two separate framebuffer devices (X glint driver
on top of pm2fb, debug messages on amifb), but I think even that case
isn't possible ATM. I agree it would be nice, though realistically
there's hardly a way around a second machine for graphics driver
development anyway.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
