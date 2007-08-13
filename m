Return-Path: <linux-kernel-owner+w=401wt.eu-S969270AbXHMPvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969270AbXHMPvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946492AbXHMOMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:12:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51704 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946484AbXHMOMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:12:32 -0400
Date: Mon, 13 Aug 2007 16:12:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       andrea@suse.de, npiggin@suse.de
Subject: Re: min_free_kbytes documentation, /proc/sys/vm docs
Message-ID: <20070813141231.GA9834@atrey.karlin.mff.cuni.cz>
References: <20070813134626.GA7305@atrey.karlin.mff.cuni.cz> <1187013180.20108.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187013180.20108.59.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > min_free_kbytes documentation says:
> > 
> > min_free_kbytes:
> > 
> > This is used to force the Linux VM to keep a minimum number 
> > of kilobytes free.  The VM uses this number to compute a pages_min
> > value for each lowmem zone in the system.  Each lowmem zone gets 
> > a number of reserved free pages based proportionally on its size.
> > 
> > ....which is not too helpful :-(. In particular, should kernel survive
> > setting this to 0 and still work reliably? IOW is this
> > performance-only tweak, or does it correctness implications?
> 
> correctness
> 
> sort-of, since PF_MEMALLOC usage is currently un-bounded.

/me is scared. If this is for correctness... why is it different on
different machines? Should we specify some minimum value in the
documentation?

> > I guess it should also say something like "do not set this to more
> > than half of your physical RAM (or half of lowmem?) or you get an
> > instant OOM".
> 
> yeah, lowmem, not sure on the oom part, it should work with quite high
> limits, although I've never tried it with ridiculous numbers.

I did, and it indeed OOMs instantly.

Perhaps something like this should be applied?

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index a0ccc5b..e460c19 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -111,6 +111,12 @@ of kilobytes free.  The VM uses this num
 value for each lowmem zone in the system.  Each lowmem zone gets 
 a number of reserved free pages based proportionally on its size.
 
+Some minimal ammount of memory is needed to satisfy PF_MEMALLOC
+allocations; if you set this to lower than 1024KB, your system will
+become subtly broken, and prone to deadlock under high loads.
+
+Setting this too high will OOM your machine instantly.
+
 ==============================================================
 
 percpu_pagelist_fraction

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
