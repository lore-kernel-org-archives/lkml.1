Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYLSUrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYLSUrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYLSUrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:23 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35253 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYLSUrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:23 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/10] make link target handling more robust
Date: Fri, 19 Dec 2008 20:47:08 +0000
Message-Id: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix potential bugs associated with link target handling,
primarily by NUL-terminating names read from disk.

This is version 5 of these patches. This version fixes an off-by-one
bug, pointed out by Andreas Dilger, where the maximum name length was
calculated with sizeof without leaving space for the terminator.

This set includes patches for all affected filesystems except for jfs,
which has already been fixed by David Kleikamp, and ufs, where I am
still discussing some issues with the maintainer. I'll post the ufs
patch separately once it is ready.

The eCryptFS fix should be considered for stable.

diffstat:
 fs/9p/vfs_inode.c        |    5 +++--
 fs/befs/linuxvfs.c       |    5 ++++-
 fs/ecryptfs/inode.c      |    3 ++-
 fs/ext2/inode.c          |    7 +++++--
 fs/ext3/inode.c          |    7 +++++--
 fs/ext4/inode.c          |    7 +++++--
 fs/freevxfs/vxfs_inode.c |    4 +++-
 fs/namei.c               |    7 +++++--
 fs/sysv/inode.c          |    6 +++++-
 include/linux/namei.h    |    5 +++++
 10 files changed, 42 insertions(+), 14 deletions(-)

Cheers,
Duane,
