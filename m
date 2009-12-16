Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbZLPNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbZLPNh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933877AbZLPNhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:37:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933840AbZLPNhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:37:24 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
Date: Wed, 16 Dec 2009 14:37:31 +0100
User-Agent: KMail/1.9.1
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Mahoney <jeffm@suse.de>,
       linux-kernel@vger.kernel.org
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com> <200912131250.13797.jdelvare@suse.de> <alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912161437.32134.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Le dimanche 13 décembre 2009 22:53, Dave Airlie a écrit :
> > Are you suggesting that the "kms driver" is a drop-in replacement for
> > intelfb? More specifically, can I use that "kms driver" to get a
> > high-resolution console?
> 
> Yes, thats all it does, but you need to make sure the X.org userspace you 
> ship supports which for Intel it has done for a while.

... if and only if I need X.org at all, right? I sure hope that
installing X.org hasn't become mandatory just to have a
high-resolution console?

> > (...)
> > The proper way to handle this is not to make the driver depend on
> > EMBEDDED. The proper way would be to change the intelfb driver so
> > that it no longer binds to devices it will not properly support. If
> > the driver doesn't support LVDS (whatever it is) then it should
> > cleanly fail on systems which have that.
> 
> LVDS are laptops, adding code to fix intelfb to know when its failing
> is pointless,

I don't think it is that pointless. Failing gracefully, preferably
with a useful error message, is always important.

> kernel modesetting supports all the hw properly that intelfb fails on.

True but irrelevant. If I load a driver and it crashes my system,
that's bad, even if there is another driver available that would
not have crashed my system (and may even have made something useful
out of it.) Again, we want drivers to fail gracefully, and point the
user to alternatives if applicable.

> (...)
> We don't want distros using this driver going forward or shipping it,
> any distro that has a reason to enable it needs to enable EMBEDDED,
> 
> We cannot have two drivers for this hardware enabled by default, and

Actually we sort of can, that's the power of modules. I'm not sure
what "make allyesconfig" would do though... does it honnor
"default n" in Kconfig?

> having two options in the menus confuses users and distros alike, so
> EMBEDDED is a clear sign. I'm tempted to make it CONFIG_BROKEN.

The remaining users of the intelfb driver may disagree, but I'd
indeed prefer the driver to be marked as broken, if that's what it
is. Or even removed from the kernel tree. If they want to keep it
in the tree, they should fix it.

> > So the problem I have to solve is: given a customer who was
> > successfully using the intelfb driver before, what solutions can we
> > offer when said customer upgrades to our new product? My own solution
> > was straightforward: keep including the intelfb driver in the new
> > product. Thus my patch dropping the dependency on EMBEDDED. If
> > another solution exists, please let me know.
> 
> You can do that, just enable CONFIG_EMBEDDED, but that is a distro choice,

Enabling CONFIG_EMBEDDED would give us access to other tweaking
options that we don't want to touch, and I have no idea if any of
these is set by default. So thanks but no thanks. I'm much better
just dropping the dependency on EMBEDDED for intelfb, at least I
control the scope of this change.

> upstream this driver is dead, you should see if the KMS solution is 
> suitable for you customer and migrate them to it.

Except that I have no clue if any of my customers are actually
using it, nor who they are, nor what hardware they use. As it stands,
I would know if we were to drop intelfb in our next product, because
these customers would complain, probably loudly. But obviously this
is no solution business-wise.

If I wanted to attempt a transparent migration, where would I start?
As I recall, console on framebuffer needs specific boot parameters,
right? I don't suppose that kms will transparently pick them and do
the right thing, do I? If there documentation available on how one
can get a high resolution console using kms?

Thanks,
-- 
Jean Delvare
Suse L3
