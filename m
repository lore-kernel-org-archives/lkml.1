Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYH1Rmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYH1Rmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYH1Rma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:52418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYH1Rm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:29 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: [PATCHSET] FUSE: extend FUSE to support more operations
Date: Fri, 29 Aug 2008 02:40:56 +0900
Message-Id: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset extends FUSE such that it supports more file operations
and is consisted of the following seven patches.

  0001-FUSE-add-include-protectors.patch
  0002-FUSE-pass-nonblock-flag-to-client.patch
  0003-FUSE-implement-nonseekable-open.patch
  0004-FUSE-implement-direct-lseek-support.patch
  0005-FUSE-implement-ioctl-support.patch
  0006-FUSE-implement-unsolicited-notification.patch
  0007-FUSE-implement-poll-support.patch

The added features will be used primarily for CUSE but can be used by
any FUSE client.  Accompanying libfuse updates will be posted
separately.

This patchset is on top of

  2.6.27-rc4 (b8e6c91c74e9f0279b7c51048779b3d62da60b88)
+ [1] 9p-use-single-poller patchset
+ [2] wait-kill-is_sync_wait
+ [3] poll-allow-f_op_poll-to-sleep

The above three patches allow f_op->poll() to sleep and 0007 depends
on it.

This patchset is available in the following git tree.

 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=extend-fuse
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git extend-fuse

and contains the following changes.

 fs/fuse/dev.c        |   49 +++++
 fs/fuse/file.c       |  446 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h     |   31 +++
 fs/fuse/inode.c      |    5 
 include/linux/fuse.h |   82 +++++++++
 5 files changed, 599 insertions(+), 14 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/726098
[2] http://article.gmane.org/gmane.linux.kernel/726176
[3] http://article.gmane.org/gmane.linux.kernel/726178
