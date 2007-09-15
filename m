Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXIORYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXIORYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXIORYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:24:24 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:35907 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXIORYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:24:22 -0400
Date: Sat, 15 Sep 2007 11:24:46 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
Message-ID: <20070915172446.GC2990@schatzie.adilger.int>
Mail-Followup-To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070915122957.GA25752@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915122957.GA25752@2ka.mipt.ru>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 15, 2007  16:29 +0400, Evgeniy Polyakov wrote:
> Yes, block device itself is not able to scale well, but it is the place
> for redundancy, since filesystem will just fail if underlying device
> does not work correctly and FS actually does not know about where it
> should place redundancy bits - it might happen to be the same broken 
> disk, so I created a low-level device which distribute requests itself.

I actually think there is a place for this - and improvements are
definitely welcome.  Even Lustre needs block-device level redundancy
currently, though we will be working to make Lustre-level redundancy
available in the future (the problem is WAY harder than it seems at
first glance, if you allow writeback caches at the clients and servers).

> When Chris Mason announced btrfs, I found that quite a few new ideas 
> are already implemented there, so I postponed project (although
> direction of the developement of the btrfs seems to move to the zfs side
> with some questionable imho points, so I think I can jump to the wagon
> of new filesystems right now). 

This is an area I'm always a bit sad about in OSS development - the need
everyone has to make a new {fs, editor, gui, etc} themselves instead of
spending more time improving the work we already have.  Imagine where the
internet would be (or not) if there were 50 different network protocols
instead of TCP/IP?  If you don't like some things about btrfs, maybe you
can fix them?

To be honest, developing a new filesystem that is actually widely useful
and used is a very time consuming task (see Reiserfs and Reiser4).  It
takes many years before the code is reliable enough for people to trust it,
so most likely any effort you put into this would be wasted unless you can
come up with something that is dramatically better than something existing.

The part that bothers me is that this same effort could have been used to
improve something that more people would use (btrfs in this case).  Of
course, sometimes the new code is substantially better than what currently
exists, and I think btrfs may have laid claim to the current generation of
filesystems.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

