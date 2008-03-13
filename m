Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYCML20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYCML20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCML2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:28:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:56370 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752396AbYCML2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:28:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18rk2k1OlkrEz3bi96fEm/esyPHGSoclfMBzEbwl7
	rCP+Yo0TAMJvSD
Subject: Re: Keys get stuck
From: Mike Galbraith <efault@gmx.de>
To: Jan Knutar <jk-lkml@sci.fi>
Cc: linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
In-Reply-To: <200803131148.22056.jk-lkml@sci.fi>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
	 <200803122222.05663.hpj@urpla.net>
	 <1205386933.4797.22.camel@marge.simson.net>
	 <200803131148.22056.jk-lkml@sci.fi>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 12:28:13 +0100
Message-Id: <1205407693.6686.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 11:48 +0200, Jan Knutar wrote:
> On Thursday 13 March 2008 07:42, Mike Galbraith wrote:
> 
> > > Just for the record, this problem started with openSUSE 10.2 for
> > > me, that's a 2.6.18 thingy. I'm a heavy xterm user, where the
> > > autorepeat gets a life of its own _occasionally_. I'm able to stop
> > > it by triggering a autorepeat manually (typical antidot reaction).
> >
> > I've seen these key repeats for years.  All I ever had to do was to
> > make X run heavily enough in the presence of another (hefty) load
> > that it hits the expired array and thereby takes a serious latency
> > hit.  I always considered key repeats under load to be X's quaint way
> > of saying "HEEEEELP MEEEE" ;-)
> 
> I experience random repeats during heavy loads  such as yum upgrade, 
> which triggers a huge swapout, in Fedora Core 7 with Fedora's 
> 2.6.23.14-64 on amd64, Xorg 1.3... Using USB keyboard.

Hm, dunno what all is in that kernel.  Huge swapout with yum upgrade
shouldn't be happening I don't think, upgrades here certainly don't (I'm
using suses upgrade dohickey though...).  I can only recommend trying
latest/greatest stock kernel.

> I'm not sure if it's the same issue or not, they don't repeat "forever" 
> for me, it just makes my speeellllliingggg   llllooookkk   
> teerrriibbblle. Like that. Before this happens, letters usually stop 
> appearing on screen as I'm typing. I usually stop typing at that point, 
> since I know it will just become a mess.

Yes, that's the symptom I was refering to.  If you see that under
reasonable CPU load, and _without_ major swapping going on, then I'd be
suspicious of scheduler trouble.  Swap can definitely keep X off the cpu
for extended periods, and that seems to be what triggers the repeated
keys behavior.  (I've never troubleshot it, so must say _seems_)

	-Mike

