Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXAaFtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXAaFtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXAaFtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:49:31 -0500
Received: from paragon.brong.net ([66.232.154.163]:52220 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbXAaFtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:49:31 -0500
Date: Wed, 31 Jan 2007 16:49:10 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Adrian Bunk <bunk@stusta.de>,
       Bron Gondwana <brong@fastmail.fm>, Mike Houston <mikeserv@bmts.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many people are using 2.6.16?
Message-ID: <20070131054910.GA10897@brong.net>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de> <45BFF1F4.3060401@rtr.ca> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 06:36:48PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 30 Jan 2007, Mark Lord wrote:
> > 
> > I believe our featherless leader said he though it was an ancient bug,
> > exasperated by something that went into 2.6.19.
> > 
> > If Linus's opinion is correct (still?), then the bug exists in all
> > kernels since somewhere back in the 2.4.xx days.
> 
> The issue was somewhat confused by people certainly *reporting* it for 
> older kernels. Also, as part of the dirty bit cleanups and sanity 
> checkingwe did actually seem to fix a long-standing CIFS corruption (and 
> apparently reisertfs/XFS problems too).
> 
> But the *common* case was actually introduced with 2.6.19, and 2.6.16 
> wouldn't be affected. 

We run on reiserfs.  I did try ext3 for a little while on a couple of
servers but performance was really awful compared to reiser, and we
heaved a sigh of relief when we finally migrated all the users off
those filesystems.  There were many complaints about the speed of our
service for a while.

I'm really hoping this is the cause, because do still see occasional
corruption of MMAPed files under heavy load, though less often now
that we've balanced our servers to the point where load spikes are
much less common.

The servers are using either internal Areca cards or LSI SCSI adaptors
connected to external SATA raid boxes.  Either way, there's a few
terabytes of SATA attached to each box, with 10kRPM drives in RAID1
for Cyrus's metadata and 7,2k bigger drives in RAID5 for the actual
emails.  According to iostat these drives are being utilised at over
50% of available bandwidth even now during the "quiet time" - there
are many tens of thousands of users per machine - so we tend to
stress the IO subsystem quite a lot.

Cyrus is also very liberal in its use of MMAP, so we get to push
all sorts of exciting edge cases.  We were still applying patches
to reiserfs until recently, and I'm not sure what the status of that
is (Hans Reiser said to keep harassing him about it - but he's
hardly in a position to be dealing with our issues right now)

Thankfully, now that we're using 300Gb maximum rather than 2Tb
partitions (running multiple instances of Cyrus instead) with
the associated smaller mailboxes.db (the biggest MMAPed and
frequently updated file) things seem less edgy.  I don't like
edgy (queue Ubuntu jokes).

Anyway, I'm hoping to update one of our boxes to 2.6.19.2 soon.
We do have one box running a 2.6.18 series kernel which has been
fine as well.  I'll give feedback if we see any issues with MMAP
on there.

Bron.
