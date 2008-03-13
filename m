Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbYCMHN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbYCMHN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYCMHNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:13:12 -0400
Received: from phunq.net ([64.81.85.152]:53904 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751139AbYCMHMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:12:54 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 23:12:35 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803122317.24849.phillips@phunq.net> <alpine.DEB.1.00.0803122327260.3786@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803122327260.3786@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130012.36763.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 23:32, david@lang.hm wrote:
> looking at the comparison of a 500G filesystem with 500G of ram allocated 
> for a buffer cache.
> 
> yes, initially it will be a bit slower (until the files get into the 
> buffer cache), and if fsync is disabled all writes will go to the buffer 
> cache (until writeout hits)
> 
> I may be able to see room for a few percent difference, but not 2x, let 
> alone 25x.

My test ran 25 times faster because it was write intensive and included
sync.  It did not however include seeks, which can cause an even bigger
performance gap.

The truth is, my system has _more_ cache available for file buffering
than I used for the ramdisk, and almost every file operation I do
(typically dozens of tree diffs, hundreds of compiles per day) goes
_way_ faster on the ram disk.  Really, really a lot faster.  Because
frankly, Linux is not very good at using its file cache these days.
Somebody ought to fix that.  (I am busy fixing other things.)

In other, _real world_ NFS file serving tests, we have seen 20 - 200
times speedup in serving snapshotted volumes via NFS, using ddsnap
for snapshots and replication.  While it is true that ddsnap will
eventually be optimized to improved performance on spinning media,
I seriously doubt it will ever get closer than a factor of 20 or so,
with a typical read/write mix.

But that is just the pragmatic reality of machines everybody has these
days, let us not get too wrapped up in that.  Think about the Violin
box.  How are you going to put 504 gigabytes of data in buffer cache?
Tell me how a transaction processing system is going to run with
latency measured in microseconds, backed by hard disk, ever?

Really guys, ramdisks are fast.  Admit it, they are really really fast.
So I provide a way to make them persistent also.  For free, I might
add.

Why am I reminded of old arguments like "if men were meant to fly, God
would have given them wings"?  Please just give me your microsecond
scale transaction processing solution and I will be impressed and
grateful.  Until then... here is mine.  Service with a smile.

Daniel
