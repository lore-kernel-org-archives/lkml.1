Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZEUUBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZEUUBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZEUUBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:01:11 -0400
Received: from thunk.org ([69.25.196.29]:39198 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbZEUUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [RFC PATCH 0/5] Put struct inode on a diet
Date: Thu, 21 May 2009 16:00:58 -0400
Message-Id: <1242936063-31689-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.1.1.g75fc.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches attempt to slim down struct inode to reduce the overhead
of storing cached inodes.  A typical Linux system has hundreds of
thousands of inodes cached, if not more, so reducing the inode size is a
high leverage thing to do.  For example these patches save 24 bytes, or
a little over 4% of an inode (with no debugging enabled) on an x86_64
machine.  But on a system with 160,000 inodes in its inode cache, this
might mean a difference of six and half megabytes of physical memory
(once SLAB rounding issues are taken into account).

Theodore Ts'o (5):
  fs: i_flags and i_state in struct inode only need to be unsigned
    short
  fs: Remove i_cindex from struct inode
  fs: Slim down inode by only using an unsigned int for i_dnotify_mask
  fs: Rearrange inode structure elements to avoid waste due to padding
  Dump the inode structure (for debugging purposes only)

 drivers/ieee1394/dv1394.c        |    5 +-
 drivers/ieee1394/ieee1394_core.h |    5 ++-
 fs/Makefile                      |    1 +
 fs/char_dev.c                    |   14 ++++++-
 fs/inode-struct-dumper.c         |   87 ++++++++++++++++++++++++++++++++++++++
 include/linux/cdev.h             |    2 +
 include/linux/dnotify.h          |    2 +-
 include/linux/fs.h               |    9 ++--
 8 files changed, 115 insertions(+), 10 deletions(-)
 create mode 100644 fs/inode-struct-dumper.c

