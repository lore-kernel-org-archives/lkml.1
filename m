Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbXGVEKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbXGVEKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 00:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbXGVEK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 00:10:27 -0400
Received: from [212.12.190.150] ([212.12.190.150]:33559 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750707AbXGVEK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 00:10:26 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-raid@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
Date: Sun, 22 Jul 2007 07:10:31 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org>
In-Reply-To: <20070722011141.GJ26752@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220710.31402.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sat, Jul 21, 2007 at 07:54:14PM +0200, Rene Herman wrote:
> > sfdisk -d already works most of the time. Not as a verbatim tool (I
> > actually semi-frequently use a "sfdisk -d /dev/hda | sfdisk" invocation
> > as a way to _rewrite_ the CHS fields to other values after changing
> > machines around on a disk) but something you'd backup on the FS level
> > should, in my opinion, need to be less fragile than would be possible
> > with just 512 bytes available.
>
> *IF* you remember to store the sfdisk -d somewhere useful.  In my "How
> To Recover From Hard Drive Catastrophies" classes, I tell them to
> print out a copy of "sfdisk -l /dev/hda ; sfdisk -d /dev/hda" and tape
> it to the side of the computer.  I also tell them do regular backups.
> What to make a guess how many them actually follow this good advice?
> Far fewer than I would like, I suspect...
>
> What I'm suggesting is the equivalent of sfdisk -d, except we'd be
> doing it automatically without requiring the user to take any kind of
> explicit action.  Is it perfect?  No, although the edge conditions are
> quite rare these days and generally involve users using legacy systems
> and/or doing Weird Shit such that They Really Should Know To Do Their
> Own Explicit Backups.  But for the novice users, it should work Just
> Fine.

Sounds great, but it may be advisable to hook this into the partition 
modification routines instead of mkfs/fsck.  Which would mean that the 
partition manager could ask the kernel to instruct its fs subsystem to 
update the backup partition table for each known fs-type that supports such 
a feature.


Thanks!

--
Al

