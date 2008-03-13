Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYCMMCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYCMMCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYCMMCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:02:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:56389 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754449AbYCMMCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:02:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18+D8okFkM+990g/PkcPDadZDwHDrk+9K3iPnoCC7
	Z2BH3eNby9ntvv
Subject: Re: Keys get stuck
From: Mike Galbraith <efault@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Knutar <jk-lkml@sci.fi>, linux-kernel@vger.kernel.org,
       Hans-Peter Jansen <hpj@urpla.net>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0803131230230.30831@jikos.suse.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
	 <200803122222.05663.hpj@urpla.net>
	 <1205386933.4797.22.camel@marge.simson.net>
	 <200803131148.22056.jk-lkml@sci.fi>
	 <1205407693.6686.16.camel@marge.simson.net>
	 <Pine.LNX.4.64.0803131230230.30831@jikos.suse.cz>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 13:02:01 +0100
Message-Id: <1205409721.6686.48.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 12:31 +0100, Jiri Kosina wrote:
> On Thu, 13 Mar 2008, Mike Galbraith wrote:
> 
> > > I'm not sure if it's the same issue or not, they don't repeat 
> > > "forever" for me, it just makes my speeellllliingggg llllooookkk 
> > > teerrriibbblle. Like that. Before this happens, letters usually stop 
> > > appearing on screen as I'm typing. I usually stop typing at that 
> > > point, since I know it will just become a mess.
> > Yes, that's the symptom I was refering to.  If you see that under
> > reasonable CPU load, and _without_ major swapping going on, then I'd be
> > suspicious of scheduler trouble.  Swap can definitely keep X off the cpu
> > for extended periods, and that seems to be what triggers the repeated
> > keys behavior.  (I've never troubleshot it, so must say _seems_)
> 
> I have a hard time calling this a kernel scheduler trouble. My 
> understanding is that X are sometimes unhappy how kernel schedules them 
> when under load, and that triggers bug in X autorepeat code.

Only if X is not getting CPU for long periods without swapping would I
become suspicious of the scheduler.  We recently had exactly this
trouble with the fair groups load balancing code (now reverted) and CPU
bound loads.  The bug is a symptom of latency woes, and the scheduler is
just one potential source worth watching.  In the heavy swapping case,
it's unlikely to be scheduler trouble, and yes, the bug lies elsewhere.

	-Mike

