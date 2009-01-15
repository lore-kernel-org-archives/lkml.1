Return-Path: <linux-kernel-owner+w=401wt.eu-S937356AbZAPTPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937356AbZAPTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937024AbZAPTMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:12:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36253 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937152AbZAPTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:12:30 -0500
Date: Thu, 15 Jan 2009 09:10:06 +0100
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] V3 of the async function call patches
Message-ID: <20090115081006.GB1599@ucw.cz>
References: <20090107151151.458333c1@infradead.org> <alpine.LFD.2.00.0901071611490.3283@localhost.localdomain> <20090107172102.47f778d4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107172102.47f778d4@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > My dmesg shows:
> > 
> >  [    2.264955] sd 5:0:0:0: [sdb] Write cache: enabled, read cache:
> > enabled, doesn't support DPO or FUA [    2.264958]  sdb:<6>Freeing
> > unused kernel memory: 408k freed
> > 
> > Ouch. How come that "Freeing unused kernel memory" got done in the
> > middle of the sdb partition thing?
> > 
> > There's a async_synchronize_full() there before the free_initmem(),
> > but I'm worrying that it just isn't working. Hmm? What am I missing?
> > 
> 
> ok this part looks funny but it's not really (and it's safe I think).
> 
> The async sata thing launches another async thing (the scsi partition
> scan).
> The synchronize_full() waits for the sata to complete, but doesn't wait
> for things that the sata async schedules after the wait started.
> 
> is this a problem? not right now, but it means we have a rule that if
> an async item schedules another async item, the second one cannot be
> __init. (which is ok right now.. scsi already had some of this async
> anyway).
> 
> I could make the async_full() be more strict if that makes you feel
> better, but for this specific purpose it would be over-synchronizing.

Really? If you run userspace before partitions are ready, its attempts
to read partitions will result in problems, right?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
