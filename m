Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYH1SUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYH1SUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYH1SUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:20:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:41682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYH1SU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:20:29 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: [PATCHSET] CUSE: implement CUSE
Date: Fri, 29 Aug 2008 03:18:59 +0900
Message-Id: <1219947544-666-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:20:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements CUSE - Character device in Userspace.  Except
for initialization sequence and creation of character device instead
of a mount, CUSE isn't very different from FUSE.

This patchset is consisted of the following five patches.

  0001-FUSE-add-fuse_-prefix-to-several-functions.patch
  0002-FUSE-export-symbols-to-be-used-by-CUSE.patch
  0003-FUSE-separate-out-fuse_conn_init-from-new_conn.patch
  0004-FUSE-add-fuse_conn-release.patch
  0005-CUSE-implement-CUSE-Character-device-in-Userspace.patch

0001-0004 prepares FUSE for CUSE addition and 0005 implements CUSE.
Corresponding libfuse changes will be posted separately.

This patchset is on top of...

  2.6.27-rc4 (b8e6c91c74e9f0279b7c51048779b3d62da60b88)
+ [1] 9p-use-single-poller patchset
+ [2] wait-kill-is_sync_wait
+ [3] poll-allow-f_op_poll-to-sleep
+ [4] uevent updates (2 patches)
+ [5] char_dev-add-release
+ [6] extend-FUSE patchset

The above three patches allow f_op->poll() to sleep and 0007 depends
on it.

This patchset is available in the following git tree.

 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=cuse
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cuse

and contains the following changes.

 fs/Kconfig           |   10 
 fs/fuse/Makefile     |    1 
 fs/fuse/cuse.c       |  634 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev.c        |   32 +-
 fs/fuse/dir.c        |   34 +-
 fs/fuse/file.c       |   60 ++--
 fs/fuse/fuse_i.h     |   46 +++
 fs/fuse/inode.c      |  143 ++++++-----
 include/linux/cuse.h |   40 +++
 include/linux/fuse.h |    2 
 10 files changed, 882 insertions(+), 120 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/726098
[2] http://article.gmane.org/gmane.linux.kernel/726176
[3] http://article.gmane.org/gmane.linux.kernel/726178
[4] http://thread.gmane.org/gmane.linux.kernel/727127
[5] http://article.gmane.org/gmane.linux.kernel/727133
[6] http://thread.gmane.org/gmane.linux.kernel/727161
