Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYC1WQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYC1WQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYC1WQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:16:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38182 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbYC1WQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:16:28 -0400
Date: Fri, 28 Mar 2008 22:16:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] more vfs fixes
Message-ID: <20080328221627.GG10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanitized locking for ->mnt_expiry, race fixes for shrink_submounts(),
some stack footprint reduction on using struct path instead of struct
nameidata in several places in namespace.c (more will be possible once
we sanitize prototypes of several LSM hooks, but that's post-25).

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (5):
      reduce stack footprint in namespace.c
      count ghost references to vfsmounts
      sanitize locking in mark_mounts_for_expiry() and shrink_submounts()
      do shrink_submounts() for all fs types
      mnt_expire is protected by namespace_sem, no need for vfsmount_lock

Diffstat:
 fs/afs/internal.h      |    1 -
 fs/afs/mntpt.c         |    8 --
 fs/afs/super.c         |    1 -
 fs/cifs/cifs_dfs_ref.c |    1 -
 fs/namespace.c         |  200 +++++++++++++++++-------------------------------
 fs/nfs/super.c         |    2 -
 fs/pnode.c             |    2 +-
 include/linux/mount.h  |    2 +-
 8 files changed, 71 insertions(+), 146 deletions(-)

