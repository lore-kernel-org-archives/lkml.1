Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZAJKMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZAJKMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZAJKMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:12:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36218 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZAJKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:12:07 -0500
Date: Thu, 8 Jan 2009 14:22:49 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, jack@suse.cz
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090108132248.GD2247@ucw.cz>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org> <20090106232418.GB25103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106232418.GB25103@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'm not sure this is a good idea.  Concurrent syncs are a bad idea
> > > to start with and we should just synchronyze do_sync completely.
> > > sync_filesystems as one of the main components of do_sync already
> > > is synchronized in that way, and taking that to a higher level would
> > > get rid of all the worries about concurrent syncs.
> > 
> > Yes, single-threading sys_sync() would fix the problem which that patch
> > addresses.
> > 
> > However there are a lot of performance and correctness issues around
> > sys_sync()-versus-fsync(), etc for which such a simple fix won't be
> > acceptable.
> 
> fsync should really not much interac with sync at that level.  While
> they both end up at same primitives at the lowest level those aren't
> the ones we're trying to protect against.  I'm currently in the process
> of a major rework of sys_sync/do_sync to make it work properly for
> modern filesystems and the global synchronization was one of the first
> things I did..
> 
> So if you have any workloads where that causes a problem please send
> them my way.  Not that I can really thing of them, given the global
> nature of sys_sync I can't see any benefit of doing multiple of these
> in parallel.

I did play with fsync() a bit, and realized it mostly does not
work. (Yes, I did physically unplug the media). I have some scripts,
and am currently converting them to nbd so that I will not have to
physically pull anything.

Jack has some ext2 fix provoked by those tests...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
