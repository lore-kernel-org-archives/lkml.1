Return-Path: <linux-kernel-owner+w=401wt.eu-S1031173AbXDZLKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031173AbXDZLKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030621AbXDZLKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:10:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51824 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932184AbXDZLKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:10:15 -0400
Date: Thu, 26 Apr 2007 13:09:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426110953.GQ17387@elf.ucw.cz>
References: <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <1177585458.6814.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177585458.6814.45.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > I believe uswsusp user/kernel separation is clean enough. Kernel
> > > > provides "snapshot image" and "resume image". (Thanks go to Rafael for
> > > > very clean interface).
> > > 
> > > The interface isn't even 64/32-bit compatible...
> > 
> > Which parts?
> 
> ioctl numbers last time I talked about it with Rafael. No effort was
> made to fix it.

#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
#define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
#define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)

Are these a problem? Do we need to just use u32 as a argument to keep
ioctl numbers same between 32 and 64bit versions?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
