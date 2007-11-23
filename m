Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbXKWAVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbXKWAVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXKWAVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:21:37 -0500
Received: from waste.org ([66.93.16.53]:44491 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbXKWAVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:21:37 -0500
Date: Thu, 22 Nov 2007 18:20:31 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071123002031.GT19691@waste.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com> <20071122072549.GQ19691@waste.org> <20071122103159.GW114266761@sgi.com> <20071122181029.GR19691@waste.org> <20071122222909.GY114266761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122222909.GY114266761@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 09:29:09AM +1100, David Chinner wrote:
> On Thu, Nov 22, 2007 at 12:10:29PM -0600, Matt Mackall wrote:
> > On Thu, Nov 22, 2007 at 09:31:59PM +1100, David Chinner wrote:
> > [...]
> > > > In other words, I/O priority is per-spindle and not per-filesystem and
> > > > thus this change has consequences that leak outside the filesystem in
> > > > question. That's bad.
> > > 
> > > This has nothing to do with this patch - it's a problem with sharing
> > > a single resource in a RT system between two non-deterministic
> > > constructs. e.g. I can put two ext3 filesystems on the one spindle,
> > > run two completely independent RT workloads on the different
> > > filesystems and have one workload DOS the other due to differences
> > > in priority at the spindle.
> > 
> > Sure. And it's up to the RT system designer not to do something stupid
> > like that. The problem is that your patch potentially promotes a
> > non-RT I/O activity to an RT one without regard to the rest of the
> > system.
> 
> So this:
> 
> http://marc.info/?l=linux-kernel&m=119247074517414&w=2
> 
> shouldn't be allowed, either? (rt kjournald for ext3)

No, I think not. If a user wants to manually promote kjournald, that's fine.

> > Perfectly understood. And that's fine. A system designer is allowed to
> > shoot himself in the foot.
> 
> Ok. I'll point anyone that complains at you, Matt ;)
> 
> > I don't think there's any fundamental reason the I/O subsystem or
> > filesystems can't be taught to handle priority inversion, which is
> > much more acceptable and general fix.
> 
> See my reply to Andi.

I did. And I'll admit it's pretty thorny and I certainly don't know
enough about XFS internals to comment further.

> > If I've got XFS on filesystems A and B on the same spindle (or volume
> > group?) and my real RT I/O takes place only on B, then I want log
> > flushing to happen in RT on B. But -never on A-. If I can do this with
> > a tunable, I'm perfectly happy.
> 
> No, not another mount option. I'm just going to drop this one for
> now...

I was actually just suggesting allowing a user to do ioprio_set on the
appropriate kernel threads.

-- 
Mathematics is the supreme nostalgia of our time.
