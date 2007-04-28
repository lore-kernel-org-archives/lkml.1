Return-Path: <linux-kernel-owner+akpm=40zip.com.au-S1161742AbXD1Ium@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161742AbXD1Ium (ORCPT <rfc822;akpm@zip.com.au>);
	Sat, 28 Apr 2007 04:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161751AbXD1Ium
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:50:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51660 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161742AbXD1IuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:50:10 -0400
Date: Sat, 28 Apr 2007 10:50:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nigel Cunningham <nigel@nigel.suspend2.net>,
        Pekka J Enberg <penberg@cs.helsinki.fi>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
Message-ID: <20070428085000.GA3293@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280300.22604.rjw@sisk.pl> <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org> <200704280344.49674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704280344.49674.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In many ways, "at all".
> > 
> > I _do_ realize the IO request queue issues, and that we cannot actually do 
> > s2ram with some devices in the middle of a DMA. So we want to be able to 
> > avoid *that*, there's no question about that. And I suspect that stopping 
> > user threads and then waiting for a sync is practically one of the easier 
> > ways to do so.
> > 
> > So in practice, the "at all" may become a "why freeze kernel threads?" and 
> > freezing user threads I don't find really objectionable.
> > 
> > But as Paul pointed out, Linux on the old powerpc Mac hardware was 
> > actually rather famous for having working (and reliable) suspend long 
> > before it worked even remotely reliably on PC's. And they didn't do even
> > that.
> > 
> > (They didn't have ACPI, and they had a much more limited set of devices, 
> > but the whole process freezer is really about neither of those issues. The 
> > wild and wacky PC hardware has its problems, but that's _one_ thing we 
> > can't blame PC hardware for ;)
> 
> We freeze user space processes for the reasons that you have quoted above.
> 
> Why we freeze kernel threads in there too is a good question, but not for me to
> answer.  I don't know.  Pavel should know, I think.

We do not want kernel threads running:

a) they may hold some locks and deadlock suspend

b) they may do some writes to disk, leading to corruption

We could solve a) by carefully auditing suspend lock usage to make
sure deadlocks are impossible even with kernel threads running.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
