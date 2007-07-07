Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbXGGXdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbXGGXdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 19:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXGGXdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 19:33:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47077 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059AbXGGXdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 19:33:36 -0400
Date: Sun, 8 Jul 2007 01:33:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070707233315.GB3820@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > We can just wait for all fuse requests to be serviced before
> > proceeding further with freeze, right?
> 
> Right.  Nice way to slow down or stop the suspend with an unprivileged
> process.  Avoiding that sort of DoS is one of the design goals of
> fuse.

So you want me to handle _malicious_ filesystems now?

That should be easy... :-). You already have nasty deadlocks in FUSE,
and you solve them by "root can echo 1 > abort"... so allow me the
same possibility.

We can tell fused we are freezing, and if all the requests are not
serviced within, say, 30 seconds, we call the filesystem malicious and
do echo 1 > abort.

Not ideal, but neither is allowing malicious filesystems in the first
place...

> Look at it this way: the task of the freezer is to stop new I/O
> hitting the hardware.  But it is totally indiscriminate about what it
> stops, it tries to stop _everything_ even things which have nothing to
> do with hardware.
> 
> Not nice.

Not nice, but we don't know any better for now. "Just fix all the
drivers" basically means "just fix 90% of kernel".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
