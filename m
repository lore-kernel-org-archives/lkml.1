Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYCOVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYCOVrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYCOVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:47:17 -0400
Received: from phunq.net ([64.81.85.152]:38428 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752155AbYCOVrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:47:16 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 13:47:00 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151322.48688.phillips@phunq.net> <20080315213309.GA4313@elf.ucw.cz>
In-Reply-To: <20080315213309.GA4313@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151447.01801.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 14:33, Pavel Machek wrote:
> On Sat 2008-03-15 12:22:47, Daniel Phillips wrote:
> > On Saturday 15 March 2008 06:32, Pavel Machek wrote:
> > > On Wed 2008-03-12 22:50:55, Daniel Phillips wrote:
> > > > On Wednesday 12 March 2008 23:30, David Newall wrote:
> > > > > Daniel Phillips wrote:
> > > > > >> Your idea seems predicated on throwing large amounts of RAM at the
> > > > > >> problem.  What I want to know is this: Is it really 25 times faster than
> > > > > >> ext3 with an equally huge buffer cache?
> > > > > >
> > > > > > Yes.
> > > > > 
> > > > > Well, that sounds convincing.  Not.  You know this how?
> > > > 
> > > > By measuring it.  time untar -xf linux-2.2.26.tar; time sync
> > > 
> > > Thats cheating. Your ramback ignores sync.
> > > 
> > > Just time it against ext3 _without_ doing the sync. That's still more
> > > reliable than what you have.
> > 
> > No, that allows ext3 to cheat, because ext3 does not supply any means
> > of flushing its cached data to disk in response to loss of line power,
> > and then continuing on in a "safe" mode until line power comes back.
> 
> Ok, it seems like "ignore sync/fsync unless on UPS power" is what you
> really want? That should be easy enough to implement, either in
> kernelor as a LD_PRELOAD hack.

Sure, let's try it and then we will have a race.  I would be happy to
lose that race, but... let's just see who wins.

> So... untar with    sync is fair benchmark against ramback on UPS power
> and   untar without sync is fair benchmark against ramback on AC power.
> 
> But you did untar with sync                against ramback on AC power.
> 
> That's wrong.

It is consistent and correct.  You need to supply the missing features
that ramback supplies before you have a filesystem-level solution.  I
really encourage you to try it, then we can compare the two approaches
with both of them fully working.

Daniel
