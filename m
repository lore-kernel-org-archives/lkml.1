Return-Path: <linux-kernel-owner+w=401wt.eu-S1764967AbYBUVLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764967AbYBUVLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYBUVLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:11:37 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13163 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYBUVLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:11:35 -0500
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: [ANNOUNCE] Btrfs v0.13
Date: Thu, 21 Feb 2008 16:09:49 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211609.50563.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Btrfs v0.13 is now available for download from:

http://oss.oracle.com/projects/btrfs/

We took another short break from the multi-device code to make the minor mods 
required to compile on 2.6.25, fix some problematic bugs and do more tuning.

The most important fix is for file data checksumming errors.  These might show 
up on .o files from compiles or other files where seeky writes were done 
internally to fill it up.   The end result was a bunch of zeros in the file 
where people expected their data to be.  Thanks to Yan Zheng for tracking it 
down.

GregKH provided most of the 2.6.25 port with some sysfs updates.  Since the 
sysfs files are not used much and Greg has offered additional cleanups, I've 
disabled the btrfs sysfs interface on kernels older than 2.6.25.  This way he 
won't have to back port any of his changes.

Optimizations and other fixes:

* File data checksumming done in larger chunks, resulting in fewer btree 
searches and fewer kmap calls.

* CPU Optimizations for back reference removal

* CPU Optimizations for block allocation, and much more efficient searching 
through the free space cache.

* Allocation optimizations, the free space clustering code was not properly 
allocating from a cluster once it found it.  For normal mounts the fix 
improves metadata writeback, for mount -o ssd it improves everything.

* Unaligned access fixes from Dave Miller

* Btree reads are done in larger bios when possible

* i_block accounting is fixed

-chris
