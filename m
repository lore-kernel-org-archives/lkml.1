Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYCMTce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYCMTce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYCMTcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:32:25 -0400
Received: from phunq.net ([64.81.85.152]:52002 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751948AbYCMTcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:32:24 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 11:32:06 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803130216.03230.phillips@phunq.net> <alpine.DEB.1.00.0803130914320.22040@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803130914320.22040@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131232.07879.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 09:25, david@lang.hm wrote:
> On Thu, 13 Mar 2008, Daniel Phillips wrote:
> > My proposition is, you can go out and purchase hardware right now that
> > delivers 6 nines (30 seconds downtime/year) and yes, it will cost you,
> > but if that worries you then set up two (much) cheaper ones and set
> > them up as a failover cluster.  (Helps that the Violin box can connect
> > via PCI-e to two servers at the same time.)
> 
> you just use a redundant system and you no longer care how long it takes 
> to shutdown or startup a system. if you're running a datacenter that cares 
> about uptime to the point of counting 9's or buying a Violin box you are 
> already going to need redundant machines so that you can perform upgrades.

The period where you cannot access the data is downtime.  If your script
just does a cp from a disk array to the ram device you cannot just read
from the backing store in that period because you will need to fail over
to the ramdisk at some point, and you cannot just read from the ramdisk
because it is not populated yet.  My point is, you cannot implement
ramback as a two line script and expect to achieve anything resembling
continuous data availability.

I interpret your point about the script as, Ramback is trivial and easy
to implement.  That is kind of true and kind of untrue, because of the
additional requirements mentioned in my original post.

> > I say you can do this reliably.  It boils down to your power supplies.
> > You say it can't be done.  Who is right?
> 
> it also takes the faith that you will never have any unplanned shutdowns, 

Never is not the right word, but indeed that is why I wrote the story
about the rocket ship.  If you want the performance that ramback
delivers then you cover the risk of hardware failure by other,
standard means.

> since your system will loose massive amounts of data if they happen. 

Why would you assume the data is not mirrored or replicated with a
short cycle, or no other suitable fallback plan is in place?

> nobody who worries about 9's will buy into that argument. you achieve 9's 
> by figuring that things don't always work, and as a result you figure out 
> how to engineer around the failures so that when they happen you stay up. 
> manufacturers have been trying to promise that their boxes are so reliable 
> that they won't go down for decades, and they haven't suceeded yet.

All true.  Now what about the punchcard versus magnetic media story?
There was a time when magnetic domains were considered less reliable
than holes in paper cards, ironically we now think the opposite.  So
some people will have a hard time with the idea that a battery is
reliable enough to get your important cached data on to hard disk when
necessary, or that Linux is reliable enough to trust data to it, or
whatever.  They will get over it.  Battery backed data will become a
normal part of your life as progress marches on.

Daniel
