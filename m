Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbXE1KFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbXE1KFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXE1KFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:05:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44681 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbXE1KFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:05:03 -0400
Date: Mon, 28 May 2007 12:04:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070528100448.GB18276@elf.ucw.cz>
References: <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org> <20070527155738.GA20006@srcf.ucam.org> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > As far as I can tell the PPC code simply shuts down the devices without 
> > worrying about userspace at all. If this was reliable, what prevents us 
> > from simply disabling the freezer for STR?
> 
> Personally, I think that's the right thing to do. 
> 
> And by "disabling the freezer", I think we should just not call it at all. 
> However, sadly, right now it's called from common code. I'll happily take 
> a tested patch to split that code sequence up, and try to do it in 2.6.23, 
> if somebody has the energy (I'm getting to the point where I may just do 
> it myself, but my lazy nature still hopes for a STR person to step 
> forward).

I guess we should warn the driver authors, then; and decide what
driver authors should do.

If I'm video4linux driver for grabbing screen, have been suspended,
and someone asks me to read a frame, should I

a) return -ESORRYIMSUSPENDED

b) just block the caller

?

a) seems ugly to my eyes (userspace should not know about suspend).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
