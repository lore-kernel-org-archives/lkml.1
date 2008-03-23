Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYCWJeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYCWJeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYCWJeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:34:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4117 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755703AbYCWJeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:34:04 -0400
Date: Sun, 23 Mar 2008 10:33:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, david@lang.hm,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080323093346.GA4580@ucw.cz>
References: <200803092346.17556.phillips@phunq.net> <200803162252.58274.phillips@phunq.net> <47DE1A4C.9080109@davidnewall.com> <200803170125.28827.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803170125.28827.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-17 00:25:27, Daniel Phillips wrote:
> On Monday 17 March 2008 00:14, David Newall wrote:
> > >> if you are depending on replication over the network you have just limited 
> > >> your throughput to your network speed and latency.
> > >
> > > Replication does not work that way.  On each replication cycle, the
> > > differences between the most recent two volume snapshots go over the
> > > network. [...]
> > > Mirroring on the other hand, makes a realtime copy of a volume, that is
> > > never out of date.
> > 
> > I think you've just tried to obfuscate the truth.  As you have
> > described, replication does not provide full protection against data
> > loss; it loses all changes since last cycle.  Recall that it was you who
> > introduced the word "replication", in the context of guaranteeing no
> > loss of data.
> 
> You are twisting words.  I may have said that replication provides a
> point-in-time copy of a volume, which is exactly what it does, no more,
> no less.
> 
> > You still haven't investigated the benefit of your idea over a whopping
> > great buffer cache.  What's the point in all of this if it turns out, as
> > Alan hinted should be the case, that a big buffer cache gives much the
> > same performance?  You appear to have gone to a great deal of effort
> > without having performed quite simple yet obvious experiments.
> 
> A big buffer cache does not provide a guarantee that the dirty cache
> data saved to disk when line power is lost.  If you would like to

on_battery_power:

sync
mount / -oremount sync

...will of course work okay on any reasonable system. Not on yours,
because you have to do

echo i_really_mean_sync_when_i_say_sync > /hidden/file/somewhere
sync

(...which also shows that you are cheating).

Now, will you either do your homework and show that page cache is
somehow unsuitable for your job, or just stop wasting the bandwidth
with useless rants?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
