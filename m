Return-Path: <linux-kernel-owner+w=401wt.eu-S1765023AbXE2Lb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765023AbXE2Lb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbXE2LbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:31:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54744 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755010AbXE2LbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:31:15 -0400
Date: Tue, 29 May 2007 13:31:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Message-ID: <20070529113114.GB23046@elf.ucw.cz>
References: <200705270012.59177.rjw@sisk.pl> <20070528103302.GD18807@elf.ucw.cz> <200705282011.11526.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705282011.11526.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Index: linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
> > > ===================================================================
> > > --- linux-2.6.22-rc3.orig/Documentation/power/kernel_threads.txt
> > > +++ linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
> > > @@ -1,13 +1,22 @@
> > > -KERNEL THREADS
> > > +The Freezer and Kernel Threads
> > >  
> > > -
> > > -Freezer
> > > -
> > > -Upon entering a suspended state the system will freeze all
> > > -tasks. This is done by delivering pseudosignals. This affects
> > > -kernel threads, too. To successfully freeze a kernel thread
> > > -the thread has to check for the pseudosignal and enter the
> > > -refrigerator. Code to do this looks like this:
> > > +Before entering a system-wide suspend state as well as before creating a
> > > +hibernation snapshot image the system will freeze all tasks, which is done
> > > +by delivering fake signals.  This affects kernel threads too, but they won't be
> > > +frozen unless they declare that they want to.  For this purpose
> > 
> > Well... and unless thread that does disk writes or DMA _wants_ to, you
> > have nice disk corruption... It should be pointed out that it is not
> > voluntary for those types of threads.
> 
> Well, that really depends.
> 
> I think the only thing that must not be written to disk is filesystem stuff.
> The other things (eg. writing directly to block devices etc.) doesn't hurt us.

Well.. it can write anywhere it wants (filesystem or not) as long as
the system is not going to be confused after resume by its caches not
matching on-disk state. I'd prefer it not to write anywhere at all.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
