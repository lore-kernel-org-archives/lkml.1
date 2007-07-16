Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXGPKAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXGPKAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbXGPJsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:48:36 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9284 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083AbXGPJsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 11:47:14 +0200
Message-Id: <11845792671245-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.rc2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A repost of this patchset, which adds support forchaining of sg tables.
This enables much larger IO commands, since we don't have to allocate
large consecutive pieces of memory to represent the sgtable of a
huge command. Right now Linux is limited to somewhere between 128 and 256
segments, depending on the architecture. This translates into at most
512k-1mb request sizes. With this patchset, I've successfully pushed
10MiB commands through the IO stack.

This will potentially increase performance a lot on hardware that
requires larger IO commands to perform at their maximum.

Also see http://marc.info/?l=linux-kernel&m=117869783524152

To enable large IO commands for device sda, you would do:

# cd /sys/block/sda/queue
# echo 4096 > max_segments
# cat max_hw_sectors_kb  > max_sectors_kb

cat max_hw_sectors_kb to see what your largest IO size would now be.

Changes since last post:

- Rebase to current -git. Lots of SCSI drivers have been converted
  to use the sg accessor helpers, which nicely shrinks this patchset
  from 70 to 33 patches. Great!

-- 
Jens Axboe



