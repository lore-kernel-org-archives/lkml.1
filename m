Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbXGGL4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbXGGL4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXGGL4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:56:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38271 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754184AbXGGL4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:56:02 -0400
Date: Sat, 7 Jul 2007 13:49:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070707114947.GD2789@elf.ucw.cz>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <20070705091526.GA3084@elf.ucw.cz> <20070705135758.GB22177@srcf.ucam.org> <200707051628.12199.rjw@sisk.pl> <20070705142600.GB22598@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705142600.GB22598@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > And also "Userland should not depend on userland services", which is 
> > > rather more of a problem.
> > 
> > I think you're oversimplifying it, as far as FUSE is concerned.
> > 
> > Namely, if there are two userland tasks, A and B, and B is uninterruptible,
> > because A is blocked, then this is not a usual situation.
> 
> Fuse is one case of it occuring, and if we end up with more userspace 
> drivers then the problem is only going to get worse.

We'll have to solve them as they come.

Face it, hardware drivers _have_ to know about suspend/resume. Even
userspace drivers will have to know about suspend/resume, because they
need to reinit the hw during resume.

Now... most parts of kernel need to know (a bit) about suspend/resume
-- at least enough to play nicely with refrigerator. In retrospect it
is pretty obvious that this covers fused, too, unfortunately noone
noticed that when fuse was designed.

Can we try to solve the suspend vs. fuse problem now? "Just removing
the refrigerator" is not the answer. First, refrigerator is impossible
to remove in few months timeframe, and second, it does not solve the
problem anyway.

(Actually, there are two separate problems with suspend vs. fuse.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
