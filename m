Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYCOVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYCOVco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYCOVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:32:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36279 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYCOVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:32:36 -0400
Date: Sat, 15 Mar 2008 22:33:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315213309.GA4313@elf.ucw.cz>
References: <200803092346.17556.phillips@phunq.net> <200803122350.56811.phillips@phunq.net> <20080315133242.GB4828@ucw.cz> <200803151322.48688.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803151322.48688.phillips@phunq.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-03-15 12:22:47, Daniel Phillips wrote:
> On Saturday 15 March 2008 06:32, Pavel Machek wrote:
> > On Wed 2008-03-12 22:50:55, Daniel Phillips wrote:
> > > On Wednesday 12 March 2008 23:30, David Newall wrote:
> > > > Daniel Phillips wrote:
> > > > >> Your idea seems predicated on throwing large amounts of RAM at the
> > > > >> problem.  What I want to know is this: Is it really 25 times faster than
> > > > >> ext3 with an equally huge buffer cache?
> > > > >
> > > > > Yes.
> > > > 
> > > > Well, that sounds convincing.  Not.  You know this how?
> > > 
> > > By measuring it.  time untar -xf linux-2.2.26.tar; time sync
> > 
> > Thats cheating. Your ramback ignores sync.
> > 
> > Just time it against ext3 _without_ doing the sync. That's still more
> > reliable than what you have.
> 
> No, that allows ext3 to cheat, because ext3 does not supply any means
> of flushing its cached data to disk in response to loss of line power,
> and then continuing on in a "safe" mode until line power comes back.

Ok, it seems like "ignore sync/fsync unless on UPS power" is what you
really want? That should be easy enough to implement, either in
kernelor as a LD_PRELOAD hack.

So... untar with    sync is fair benchmark against ramback on UPS power
and   untar without sync is fair benchmark against ramback on AC power.

But you did untar with sync                against ramback on AC power.

That's wrong.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
