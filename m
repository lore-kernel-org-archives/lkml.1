Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYCOVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYCOVGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYCOVGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:06:11 -0400
Received: from phunq.net ([64.81.85.152]:55456 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbYCOVGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:06:10 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 13:05:59 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, david@lang.hm,
       Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803131303.04118.phillips@phunq.net> <20080315202625.GC4193@ucw.cz>
In-Reply-To: <20080315202625.GC4193@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151406.00410.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 13:26, Pavel Machek wrote:
> On Thu 2008-03-13 12:03:03, Daniel Phillips wrote:
> > On Thursday 13 March 2008 12:50, David Newall wrote:
> > > Daniel Phillips wrote:
> > > > The period where you cannot access the data is downtime.  If your script
> > > > just does a cp from a disk array to the ram device you cannot just read
> > > > from the backing store in that period because you will need to fail over
> > > > to the ramdisk at some point, and you cannot just read from the ramdisk
> > > > because it is not populated yet.
> > > 
> > > Wouldn't a raid-1 set comprising disk + ramdisk do that with no downtime?
> > 
> > In raid1, write completion has to wait for write completion on all
> > mirror members, so writes run at disk speed.  Reads run at ramdisk
> > speed, so your proposal sounds useful, but ramback aims for high
> > write performance as well.
> 
> raid1 + kflushd tweak?
> special raid1 mode that signals completion when it hits _one_ of the
> drives, and does sync when the slower drive is idle?

Feel free :-)

This is very close to how ramback already works.  One subtlety is that
ramback does not write twice from the same application data source,
which could allow the data on the backing device to differ from the
ramdisk if the user changes it during the write.  I don't know how
important it is to protect against this bug actually, but there you
have it.  Ramback can easily to changed to write twice from the same
source just like a raid1 (in fact it originally was that way) which
would make it even more like raid1.

Adding ramback-like functionality to raid1 would be a nice
contribution.  I would fully support that but I do not have time to do
it myself.

Daniel
