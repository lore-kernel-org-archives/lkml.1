Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZGaLxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZGaLxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZGaLxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:53:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55790 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZGaLx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:53:29 -0400
Date: Fri, 31 Jul 2009 13:53:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: GFS2: Add LED support to GFS2
Message-ID: <20090731115323.GA22252@elf.ucw.cz>
References: <1248260198.3456.4.camel@localhost.localdomain> <20090729150844.GJ1534@ucw.cz> <1248882732.3298.142.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248882732.3298.142.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-29 16:52:12, Steven Whitehouse wrote:
> Hi,
> 
> On Wed, 2009-07-29 at 17:08 +0200, Pavel Machek wrote:
> > On Wed 2009-07-22 11:56:38, Steven Whitehouse wrote:
> > > >From e1fac35b9c2af276473db50fae581ef56626240c Mon Sep 17 00:00:00 2001
> > > From: Steven Whitehouse <swhiteho@redhat.com>
> > > Date: Wed, 22 Jul 2009 11:40:16 +0100
> > > Subject: [PATCH] GFS2: Add LED support to GFS2
> > > 
> > > This adds a standalone module which uses the GFS2 tracepoints
> > > as a hook to provide LED trigger events. Events can be sent
> > > when glocks change state, when glock demote requests are
> > > received (both local and remote events are included) and also
> > > when the log is flushed.
> > > 
> > > The log flush event lights the LED during the duration of the
> > > log flush event. The other two triggers light the LED for 1/10th
> > > second after the event has occurred.
> > > 
> > > I've tested this by using GFS2 in "nolock" mode on my laptop
> > > by getting it to flash the thinkpad battery LED on the various
> > > events and verified that it occurs when expected.
> > 
> > This looks way too specialized to me. Yes, it will be pretty,
> > but... there's about 100000 possible triggers. Where do we draw a
> > line? Or do we merge all of them?
> 
> There might be a lot of possible triggers, but that doesn't mean there
> are actually a lot of actual triggers. Surely what makes the LED
> subsystem useful is that is can show a wide variety of events?

Well... OTOH if someone wants his led to trigger to the beat of music,
will we add such triggers? And another trigger for "ext2 is full"
event? And another for "ext3 is full"?

> Whether or not it is merged ought to be down to whether it affects
> anything else (which is doesn't as it is self-contained) whether the
> code is maintainable, and whether it makes sense as a feature I think.

Perhaps GFS should get and interface where it passes the events to the
userland, and userland should toggle the LEDs? That way, you can
select which exact events you are interested in, and how long after
the event occured the LED should be lit...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
