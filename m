Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbXE2NHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbXE2NHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXE2NHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:07:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53344 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751990AbXE2NHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:07:42 -0400
Date: Tue, 29 May 2007 14:48:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Message-ID: <20070529124816.GI23046@elf.ucw.cz>
References: <200705270012.59177.rjw@sisk.pl> <200705282011.11526.rjw@sisk.pl> <20070529113114.GB23046@elf.ucw.cz> <200705291415.31970.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705291415.31970.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well.. it can write anywhere it wants (filesystem or not) as long as
> > the system is not going to be confused after resume by its caches not
> > matching on-disk state. I'd prefer it not to write anywhere at all.
> 
> OK
> 
> Please have a look at the current version of the patch (appended).
> 
> I have followed the Nigel's suggestion not to change the current behavior
> in this patch (I'll add a couple of patches removing the freezability from
> some kernel threads), with one exception: I couldn't figure out any reason
> to have try_to_freeze() called in net/sunrpc/svcsock.c:svc_recv() .

It probably broke suspend at some point... leave it there. Processes
can stay in D period, waiting for NFS server to come back.

and yes, we want nfs threads frozen, too (and anything that talks to
network). Speaking to nfs servers while we are suspending the machine
is not nice, and if that continues after snapshot, we'll act as a very
confused machine to the outside...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
