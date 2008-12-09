Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYLIXJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYLIXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYLIXJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:09:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44350 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLIXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:09:49 -0500
Date: Wed, 10 Dec 2008 00:11:31 +0100
From: Pavel Machek <pavel@suse.cz>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: Document hadling of bad memory
Message-ID: <20081209231131.GB13389@elf.ucw.cz>
References: <20081126161521.GC1983@elf.ucw.cz> <20081201105625.25ee9f32.randy.dunlap@oracle.com> <20081209123152.GA1547@ucw.cz> <200812091540.42429.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812091540.42429.rob@landley.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-09 15:40:41, Rob Landley wrote:
> On Tuesday 09 December 2008 06:31:52 Pavel Machek wrote:
> > I cleaned the document up according to Randy (thanks!). I don't actually
> > know enough about DRAM error characcteristics, I guess'round the size of
> > bad region up to nearest 2^n makes sense.
> >
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> >
> > diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
> ...
> > +This Howto is about number 3).
> >
> >
> >  BadRAM
> >  ######
> > -BadRAM is the actively developed and available as kernel-patch
> > +BadRAM is the actively developed and available as a kernel patch
> >  here:  http://rick.vanrein.org/linux/badram/
> 
> Ok, once again: the point of this patch is to document an out of tree patch.

No; the point of this piece of documentation is to tell people how to
work _without_ that patch. Because it is simple enough.

> The out of tree patch is here:
> http://rick.vanrein.org/linux/badram/software/BadRAM-2.6.27.1.patch
> 
> It has its own Documentation/badram.txt file and it patches 
> Documentation/memory.txt, as acknowledged here:
> 
> >  For more details see the BadRAM documentation.
> > @@ -27,19 +27,20 @@ For more details see the BadRAM documentation.
> >  memmap
> >  ######
> 
> Now what I don't understand is, why add something to the tree formalizing the 
> out-of-tree status of this other patch?  Why not just merge it?  If
> it's 

Take a look at that patch. It is seriously overengineered. This should
not need a config option, should not introduce new page flag, etc.

We already have perfectly working interface for excluding specific
addresses; maybe we need better documentation, and maybe kernel
commandline interface should be changed to be more user friendly, but
we certainly don't want to take the badram patch.

This excerpt should be enough:

diff -pruN linux-2.6.27/include/linux/page-flags.h
linux-2.6.27-new/include/linux/page-flags.h
--- linux-2.6.27/include/linux/page-flags.h	2008-10-10
03:43:53.000000000 +0530
+++ linux-2.6.27-new/include/linux/page-flags.h	2008-10-15
10:04:48.000000000 +0530
@@ -93,6 +93,9 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
+#ifdef CONFIG_BADRAM
+	PG_badram,              /* BadRam page */
+#endif
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #
 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
