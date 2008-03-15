Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYCOUSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYCOUSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYCOUS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:18:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2684 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbYCOUS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:18:27 -0400
Date: Sat, 15 Mar 2008 21:18:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@phunq.net>
Cc: david@lang.hm, David Newall <davidn@davidnewall.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315201815.GB4193@ucw.cz>
References: <200803092346.17556.phillips@phunq.net> <200803130106.26910.phillips@phunq.net> <alpine.DEB.1.00.0803130133470.22040@asgard.lang.hm> <200803130216.03230.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803130216.03230.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > if you have a reliable UPS and are willing to rely on it to save your data 
> > take the identical hardware to what you are planning to use, but instead 
> > of using your driver just create a ramdisk and load it on boot and save 
> > the contents on shutdown.
> 
> Aha!  You are getting close.  Really, that is all ramback does.  It
> just handles some very difficult related issues efficiently, in such a
> way as to minimize any denial of service from complete loss of UPS
> power.  This is all just about using power management in a new way that
> gets higher performance.  But your battery power has to be reliable.
> Just make it so.  It is not difficult these days, or even particularly
> expensive.
> 
> I calculated somewhere along the line that it would take something like
> 17 minutes to populate the big Violin ramdisk initially, and 17 minutes
> to save it during a loss of line power event, during which UPS power
> must be not run out before ramback achieves disk sync or you will get
> file corruption.  (This rule was mentioned in my original post.)
> 
> All well and could, you can in fact do that with a pretty simple script.
> But in the initial 17 minutes your application may not read or write
> the ramdisk data and in the closing 17 minutes it may not write.  That
> knocks your system down to 4 nines, given one planned shutdown per year.
> Not good, not good at all.

Hmm, what happens if applications keep dirtying so much data you miss
your 17minute deadline?

Anyway...
 ext2
 + lots of memory
 + tweaked settings of kflushd (only write data older than 10 years)
 + just not using sync/fsync except during shutdown
 + find / | xargs cat 
 
...is ramback, right? Should have same performance, and you can still
read/write during that 17+17 minutes.

Ok, find | xargs might be slower... but we probably want to fix that
anyway....

It has big advantage: if you only tell kflushd to hold up writes for
an hour, you loose a little in performance and gain a lot in
reliability...

(If ext2+tweaks is slower than ramback, we have a bug to fix, I'm
afraid).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
