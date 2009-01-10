Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZAJV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZAJV6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZAJV6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:58:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZAJV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:58:15 -0500
Date: Sat, 10 Jan 2009 23:12:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: sync, reboot, and corrupting data [was Re: 2.6.29 -mm merge plans]
Message-ID: <20090110221232.GH26290@one.firstfloor.org>
References: <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org> <20090106232418.GB25103@infradead.org> <20090107011448.GB3390@wotan.suse.de> <87tz8b3nfe.fsf@basil.nowhere.org> <20090107014915.GE3390@wotan.suse.de> <20090107025725.GJ496@one.firstfloor.org> <20090108132455.GE2247@ucw.cz> <20090110150729.GE26290@one.firstfloor.org> <20090110213223.GD14631@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110213223.GD14631@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 10:32:23PM +0100, Pavel Machek wrote:
> On Sat 2009-01-10 16:07:29, Andi Kleen wrote:
> > On Thu, Jan 08, 2009 at 02:24:55PM +0100, Pavel Machek wrote:
> > > On Wed 2009-01-07 03:57:25, Andi Kleen wrote:
> > > > > sys_sync B which is invoked *after* sys_sync caller A should not
> > > > > return before A. If you didn't have a global lock, they'd tend to
> > > > > block one another's pages anyway. I think it's OK.
> > > > 
> > > > It means that you cannot reboot because reboot does sync.
> > > > What happens when the sync gets stuck somewhere on a really
> > > > slow device?
> > > 
> > > And what do you propose? Silently corrupt data on the slow device?
> > 
> > Yes not writing is better than being unable to reboot.
> 
> Disagreed.

Well you're just forcing the user to press power/reset/sysrq-b which
will pretty much guarantee data loss if anything is unwritten.

> maybe reboot utility should not call sync()...

I think it should call sync(), but have a suitable timeout.
Never spend more than 10 seconds on the sync. And give user visible 
feedback during the countdown.

Now of course fixing the complete IO stack to support timeouts
might be too hard (although in theory they're already supposed
to have them, but as we know that doesn't always work reliable)

One alternative would be to do it with a background thread
(which seems to be en vogue right now anyways)
Ok I suppose with that Nick's lock is actually ok, although
I still don't like it very much.

-Andi

-- 
ak@linux.intel.com
