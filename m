Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752894AbYLQWTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYLQWTc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYLQWTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:19:19 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36062 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbYLQWTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:19:18 -0500
Subject: Re: Notes on support for multiple devices for a single filesystem
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20081217220449.GC5000@webber.adilger.int>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <20081217220449.GC5000@webber.adilger.int>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 16:19:13 -0600
Message-Id: <1229552354.19550.29.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 15:04 -0700, Andreas Dilger wrote:
> On Dec 17, 2008  08:23 -0500, Christoph Hellwig wrote:

> > An alternative way, supported by optionally by ext3 and reiserfs and
> > exclusively supported by jfs is to open the journal device by the device
> > number (dev_t) of the block special device.  While this doesn't require
> > an additional mount option when the device number is stored in the filesystem
> > superblock it relies on the device number being stable which is getting
> > increasingly unlikely in complex storage topologies.
> 
> Just as an FYI here - the dev_t stored in the ext3/4 superblock for the
> journal device is only a "cached" device.  The journal is properly
> identified by its UUID, and should the device mapping change there is a
> "journal_dev=" option that can be used to specify the new device.  The
> one shortcoming is that there is no mount.ext3 helper which does this 
> journal UUID->dev mapping and automatically passes "journal_dev=" if
> needed.

An additional FYI.  JFS also treats the dev_t in its superblock the same
way.  Since jfs relies on jfs_fsck running at boot time to ensure that
the journal is replayed, jfs_fsck makes sure that the dev_t is accurate.
If not, then it scans all of the block devices until it finds the uuid
of the journal device, updating the superblock so that the kernel will
find the journal.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

