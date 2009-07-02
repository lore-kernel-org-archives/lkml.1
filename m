Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZGBTK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZGBTK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZGBTKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:10:47 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:21784 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZGBTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:10:46 -0400
Date: Thu, 2 Jul 2009 15:10:35 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.31-rc
Message-ID: <20090702191035.GA3832@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A4D062D.0038:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Here are some btrfs updates.  Most of them are small bug fixes, but the
large commit from Yan Zheng is step one in getting snapshot deletion
rolling.  There is also has a nice CPU usage reduction for
streaming writes to a file.

Linus, please pull the master branch of btrfs-unstable:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Chris Mason (3) commits (+15/-9):
    Btrfs: don't log the inode in file_write while growing the file (+4/-1)
    Btrfs: fix the file clone ioctl for preallocated extents (+4/-2)
    Btrfs: honor nodatacow/sum mount options for new files (+7/-6)

Josef Bacik (1) commits (+11/-1):
    Btrfs: account for space we may use in fallocate

Yan Zheng (1) commits (+395/-181):
    Btrfs: update backrefs while dropping snapshot

Total: (5) commits

 fs/btrfs/ctree.h       |    3 
 fs/btrfs/extent-tree.c |  564 +++++++++++++++++++++++++++++++++----------------
 fs/btrfs/file.c        |    5 
 fs/btrfs/inode.c       |   25 +-
 fs/btrfs/ioctl.c       |    6 
 fs/btrfs/relocation.c  |    5 
 fs/btrfs/transaction.c |    4 
 7 files changed, 421 insertions(+), 191 deletions(-)
