Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZDCFDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZDCFDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 01:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbZDCFC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 01:02:56 -0400
Received: from thunk.org ([69.25.196.29]:51346 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbZDCFCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 01:02:55 -0400
Date: Fri, 3 Apr 2009 01:02:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Rees <drees76@gmail.com>
Cc: "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
Message-ID: <20090403050246.GM9870@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Rees <drees76@gmail.com>,
	"Trenton D. Adams" <trenton.d.adams@gmail.com>,
	Christian Kujau <lists@nerdbynature.de>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com> <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com> <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com> <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com> <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com> <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:58:17PM -0700, David Rees wrote:
> 
> I've got a problematic server with 8GB RAM.  Even if set both to 1,
> that's 80MB and the crappy disks I have in it will often only write
> 10-20MB/s or less due to the seekiness of the workload.  That means
> delays of 5-10 seconds worst case which isn't fun.
> 

Well, one solution is data=writeback.  If you're confident your server
isn't going to randomly crash (i.e., it's on a UPS, and you're not
running unstable video drivers), that might be a solution.  It has
tradeoffs, though.

One thing which I'll probably implement is some patches to ext3 so
that when it's in data=writeback mode, it will use the same
replace-via-rename and replace-via-truncate hueristics that I added in
ext4 so that it will start an aysnchronous writeout on the rename() or
close() w/ truncate().  That should avoid existing files getting
corrupted when they are replaced right before the system crashes.  

People will still be better off moving to ext4, but for people who
aren't quite confident in ext4's stability yet and who want to stick
with ext3, maybe it's a good short-term solution.  Maybe
data=writeback with the rename hueristic would be a better default
than data=ordered for ext3.

						- Ted
