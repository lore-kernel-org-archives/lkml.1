Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYCOVRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYCOVRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYCOVRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:17:23 -0400
Received: from phunq.net ([64.81.85.152]:37753 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbYCOVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:17:22 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 13:17:13 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803131214.40321.phillips@phunq.net> <20080315205950.GA13012@1wt.eu>
In-Reply-To: <20080315205950.GA13012@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151417.13899.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 13:59, Willy Tarreau wrote:
> On Thu, Mar 13, 2008 at 11:14:39AM -0800, Daniel Phillips wrote:
> > On Thursday 13 March 2008 06:22, Alan Cox wrote:
> > > ...Ext3 cannot recover well from massive loss of intermediate
> > > writes. It isn't a normal failure mode and there isn't sufficient fs
> > > metadata robustness for this. A log structured backing store would deal
> > > with that but all you apparently want to do is scream FUD at anyone who
> > > doesn't agree with you.
> > 
> > Scream is an exaggeration, and FUD only applies to somebody who
> > consistently overlooks the primary proposition in this design: that the
> > battery backed power supply, computer hardware and Linux are reliable
> > enough to entrust your data to them.  I say this is practical, you say
> > it is impossible, I say FUD.
> > 
> > All you are proposing is that nobody can entrust their data to any
> > hardware.  Good point.  There is no absolute reliability, only degrees
> > of it.
> > 
> > Many raid controllers now have battery backed writeback cache, which
> > is exactly the same reliability proposition as ramback, on a smaller
> > scale.  Do you refuse to entrust your corporate data to such
> > controllers?
> 
> RAID controllers do not have half a terabyte of RAM.

And?  Either you have battery backed ram with critical data in it or
you do not.  Exactly how much makes little difference to the question.

> Also, you are always 
> invited to choose between speed (write back) and reliability (write through).

As is the case with ramback.  Just echo 1 >/proc/driver/ramback/<name>.

> Also, please note that the problem here is not related to the number of
> nines of availability. This number only counts the ratio between uptime
> and downtime. We're more facing a problem of MTBF, where the consequences
> of a failure are hard to predict.

That is why I keep recommending that a ramback setup be replicated or
mirrored, which people in this thread keep glossing over.  When
replicated or mirrored, you still get the microsecond-level transaction
times, and you get the safety too.

Then there is a big class of applications where the data on the ramdisk
can be reconstructed, it is just a pain and reduces uptime.  These are
potential ramback users, and in fact I will be one of those, using it
on my kernel hacking partition.

> What I'm thinking about is that considering the fact that storage
> technologies are moving towards SSD (and I think 2008 will be the
> year of SSD), you should implement ordered writes (I've not said
> write through) since there's no seek time on those devices. Thus
> you will have the speed of RAM with the reliability of a properly
> synced FS. If your system crashes once a week, it will not be a
> problem anymore.

There will be a whole bunch of patches from me that are SSD oriented,
over time.  The fact is, enterprise scale ramdisks are here now, while
enterprise scale flash is not.  Getting close, but not here.  And flash
does not approach the write performance of RAM, not now and probably
not ever.

Daniel
