Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZLMVxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZLMVxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZLMVxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:53:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60575 "HELO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751857AbZLMVxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:53:36 -0500
Date: Sun, 13 Dec 2009 21:53:29 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jean Delvare <jdelvare@suse.de>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Mahoney <jeffm@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
In-Reply-To: <200912131250.13797.jdelvare@suse.de>
Message-ID: <alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie>
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com> <200912131250.13797.jdelvare@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >Since we merged a kms driver for Intel hw that supports all intel chipsets
> >and more importantly all the outputs on Intel chipsets, intelfb should
> >be considered legacy at the least and broken on > 50% of intel hw.
> 
> Are you suggesting that the "kms driver" is a drop-in replacement for
> intelfb? More specifically, can I use that "kms driver" to get a
> high-resolution console?

Yes, thats all it does, but you need to make suer the X.org userspace you 
ship supports which for Intel it has done for a while.

> My understanding is that the intelfb driver was not _designed_ to be
> useful on embedded designs only. It just happens to be incomplete in
> such a way that it works only in a few selected cases, which happen
> to be embedded cases, and it fails in many other cases.

Well I wrote a large chunk of it and it was for an embedded system.

> The proper way to handle this is not to make the driver depend on
> EMBEDDED. The proper way would be to change the intelfb driver so
> that it no longer binds to devices it will not properly support. If
> the driver doesn't support LVDS (whatever it is) then it should
> cleanly fail on systems which have that.

LVDS are laptops, adding code to fix intelfb to know when its failing
is pointless, kernel modesetting supports all the hw properly that intelfb
fails on.

> > If you can think of a better way of preventing users and distros
> > from accidentally selecting this,
> 
> The reason why I sent a patch in the first place is exactly opposite:
> I want to let distros select this driver. My case is as follows: we
> had a product which included the intelfb driver, which we are in the
> process of upgrading. Now we find that the intelfb driver is gone
> (no longer selectable), which causes a problem as far as the upgrade
> path of our customers is concerned.

We don't want distros using this driver going forward or shipping it,
any distro that has a reason to enable it needs to enable EMBEDDED,

We cannot have two drivers for this hardware enabled by default, and
having two options in the menus confuses users and distros alike, so
EMBEDDED is a clear sign. I'm tempted to make it CONFIG_BROKEN.

> So the problem I have to solve is: given a customer who was
> successfully using the intelfb driver before, what solutions can we
> offer when said customer upgrades to our new product? My own solution
> was straightforward: keep including the intelfb driver in the new
> product. Thus my patch dropping the dependency on EMBEDDED. If
> another solution exists, please let me know.

You can do that, just enable CONFIG_EMBEDDED, but that is a distro choice,
upsteram this driver is dead, you should see if the KMS solution is 
suitable for you customer and migrate them to it.

> First of all, I'd need to better understand how the various drivers
> relate to each other, and what functionality they provide. In my
> little outdated mind, framebuffer is for high-resolution console
> without X, while drm is for accelerated X. Apparently this changed
> more or less recently, but the documentation wasn't updated.
> 
> It would help if the DRM option description was updated. It still
> reads: "Direct Rendering Manager (XFree86 4.1.0 and higher DRI
> support)". If the DRM core is now also providing support for
> framebuffer-like functionality (again, if I understand correctly)
> then the reference to XFree86 should be dropped. The help text
> should also be updated to properly describe all that the DRM core
> offers today.

We should probably fix that alright, I'll have to think about how
we can do that.

Dave.

