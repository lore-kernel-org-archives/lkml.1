Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXGHN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXGHN7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXGHN7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:59:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXGHN7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:59:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Sun, 8 Jul 2007 16:06:37 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <20070707233315.GB3820@elf.ucw.cz> <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707081606.38771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 09:21, Miklos Szeredi wrote:
> > > > We can just wait for all fuse requests to be serviced before
> > > > proceeding further with freeze, right?
> > > 
> > > Right.  Nice way to slow down or stop the suspend with an unprivileged
> > > process.  Avoiding that sort of DoS is one of the design goals of
> > > fuse.
> > 
> > So you want me to handle _malicious_ filesystems now?
> 
> What I'd like, is a suspend, that works reliably, regardless of the
> state of any userspace filesystem, network servers and such.

And then you also would like to have a consistent state of the system after
the resume, but if the state were inconsistent before the suspend that
would be difficult to get.

> > That should be easy... :-). You already have nasty deadlocks in FUSE,
> > and you solve them by "root can echo 1 > abort"... so allow me the
> > same possibility.
> > 
> > We can tell fused we are freezing, and if all the requests are not
> > serviced within, say, 30 seconds, we call the filesystem malicious and
> > do echo 1 > abort.
> 
> Arbitrary time limits, nice.  Not.
>
> This freezer is like an old house that's close to collapsing, and you
> are basically just thinking of where to prop it up further.  To
> continute this brilliant analogy, Rafael's patch at least demolishes
> the worst part of the house, where bricks are already falling on our
> head ;)

Actually, this isn't correct and I have some testing problems with this
patch (as I expected, BTW), so it's not going anywhere.  Alternative ideas
will be appreciated. :-)

> > Not ideal, but neither is allowing malicious filesystems in the first
> > place...
> 
> Malicious programs are not something specific to fuse.  A lot of the
> multiuser/multitasking OS design is about isolating things, so such a
> program is limited in the damage it can do.
>
> > > Look at it this way: the task of the freezer is to stop new I/O
> > > hitting the hardware.  But it is totally indiscriminate about what it
> > > stops, it tries to stop _everything_ even things which have nothing to
> > > do with hardware.
> > > 
> > > Not nice.
> > 
> > Not nice, but we don't know any better for now. "Just fix all the
> > drivers" basically means "just fix 90% of kernel".
> 
> And how much of that 90% currently has any power management?

Well, you know why that actually started to be a real problem?  Because
sufficiently many people have started to use suspend/hibernation and it
actually works for quite a lot of them.  This makes people to try exotic
combinations like suspend+FUSE and they find that doesn't work.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
