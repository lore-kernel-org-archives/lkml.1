Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZAJVae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZAJVae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZAJVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:30:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54060 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:30:25 -0500
Date: Sat, 10 Jan 2009 22:32:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: sync, reboot, and corrupting data [was Re: 2.6.29 -mm merge plans]
Message-ID: <20090110213223.GD14631@elf.ucw.cz>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org> <20090106232418.GB25103@infradead.org> <20090107011448.GB3390@wotan.suse.de> <87tz8b3nfe.fsf@basil.nowhere.org> <20090107014915.GE3390@wotan.suse.de> <20090107025725.GJ496@one.firstfloor.org> <20090108132455.GE2247@ucw.cz> <20090110150729.GE26290@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110150729.GE26290@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-01-10 16:07:29, Andi Kleen wrote:
> On Thu, Jan 08, 2009 at 02:24:55PM +0100, Pavel Machek wrote:
> > On Wed 2009-01-07 03:57:25, Andi Kleen wrote:
> > > > sys_sync B which is invoked *after* sys_sync caller A should not
> > > > return before A. If you didn't have a global lock, they'd tend to
> > > > block one another's pages anyway. I think it's OK.
> > > 
> > > It means that you cannot reboot because reboot does sync.
> > > What happens when the sync gets stuck somewhere on a really
> > > slow device?
> > 
> > And what do you propose? Silently corrupt data on the slow device?
> 
> Yes not writing is better than being unable to reboot.

Disagreed.

> There should be always a timeout at least for the reboot case.

Why? If you don't want to sync the data on disk, don't call the sync
syscall.

> Consider it from a uptime perspective: if something is really
> screwed up (and that happens sometimes; classical example 
> was the IO stack getting hung up forever in error handling
> loops) the only way to get running again is to reboot and try again.

reboot() syscall should not sync.

sync() syscall should not return unless data are written on disk,
however slow that may be.

maybe reboot utility should not call sync()...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
