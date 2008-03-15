Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYCOU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYCOU0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYCOU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:26:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3320 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752643AbYCOU0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:26:36 -0400
Date: Sat, 15 Mar 2008 21:26:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, david@lang.hm,
       Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315202625.GC4193@ucw.cz>
References: <200803092346.17556.phillips@phunq.net> <200803131232.07879.phillips@phunq.net> <47D9856E.9010304@davidnewall.com> <200803131303.04118.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803131303.04118.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 12:03:03, Daniel Phillips wrote:
> On Thursday 13 March 2008 12:50, David Newall wrote:
> > Daniel Phillips wrote:
> > > The period where you cannot access the data is downtime.  If your script
> > > just does a cp from a disk array to the ram device you cannot just read
> > > from the backing store in that period because you will need to fail over
> > > to the ramdisk at some point, and you cannot just read from the ramdisk
> > > because it is not populated yet.
> > 
> > Wouldn't a raid-1 set comprising disk + ramdisk do that with no downtime?
> 
> In raid1, write completion has to wait for write completion on all
> mirror members, so writes run at disk speed.  Reads run at ramdisk
> speed, so your proposal sounds useful, but ramback aims for high
> write performance as well.

raid1 + kflushd tweak?

special raid1 mode that signals completion when it hits _one_ of the
drives, and does sync when the slower drive is idle?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
