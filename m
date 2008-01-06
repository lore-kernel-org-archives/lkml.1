Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYAFMXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYAFMXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYAFMXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:23:42 -0500
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:54710 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbYAFMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:23:41 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
References: <20080102162534.GA4041@elte.hu>
	<1199292381.3258.32.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	<20080102194030.GC11638@parisc-linux.org>
	<1199304735.3258.53.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	<1199316785.3258.85.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	<m3ir27oe7f.fsf@telia.com>
	<alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
From: Peter Osterlund <petero2@telia.com>
Date: 06 Jan 2008 11:17:46 +0100
In-Reply-To: <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
Message-ID: <m3fxxb2r79.fsf@telia.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Does a patch like this change the behaviour you see at all?

> +			bd_inode->i_size = (loff_t)get_capacity(disk)<<9;

It does fix my scenario, with the trivial fix of adding bdev-> at the
beginning of that line, ie:

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 993f78c..a8ed344 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1191,6 +1191,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
+			bdev->bd_inode->i_size = (loff_t)get_capacity(disk)<<9;
 		}
 	}
 	bdev->bd_openers++;

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
