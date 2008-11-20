Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYKTOYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYKTOYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYKTOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:23:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:46410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbYKTOXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:23:32 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, greg@kroah.com
Subject: [PATCHSET] CUSE: implement CUSE, take #2
Date: Thu, 20 Nov 2008 23:22:58 +0900
Message-Id: <1227190983-5820-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:23:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the second take of implement-CUSE patchset.  Changes from the
last take[L] are...

* hotplug_info stuff (uevent info overriding) dropped

* a lot more comments

* now uses CUSE_MINOR which is 230 and also added module alias for it

This patchset is consisted of the following five patches.

  0001-FUSE-add-fuse_-prefix-to-several-functions.patch
  0002-FUSE-export-symbols-to-be-used-by-CUSE.patch
  0003-FUSE-separate-out-fuse_conn_init-from-new_conn.patch
  0004-FUSE-add-fuse_conn-release.patch
  0005-CUSE-implement-CUSE-Character-device-in-Userspace.patch

0001-0004 prepares FUSE for CUSE addition and 0005 implements CUSE.
Corresponding libfuse changes will be posted separately.

This patchset is on top of...

  master (ee2f6cc7f9ea2542ad46070ed62ba7aa04d08871)
+ [1] poll-allow-f_op_poll-to-sleep-take-2
+ [2] add-cdev_release-and-convert-cdev_alloc-to-use-it
+ [3] extend-FUSE patchset, take #2

and is also available in the following git tree.

 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=cuse
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cuse

and contains the following changes.

 fs/Kconfig                 |   10 
 fs/fuse/Makefile           |    1 
 fs/fuse/cuse.c             |  720 +++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev.c              |   32 +-
 fs/fuse/dir.c              |   34 +-
 fs/fuse/file.c             |   61 ++-
 fs/fuse/fuse_i.h           |   45 ++
 fs/fuse/inode.c            |  145 +++++----
 include/linux/cuse.h       |   47 ++
 include/linux/fuse.h       |    2 
 include/linux/magic.h      |    5 
 include/linux/miscdevice.h |    1 
 12 files changed, 979 insertions(+), 124 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.comp.file-systems.fuse.devel/6818
[1] http://lkml.org/lkml/2008/11/20/161
[2] http://article.gmane.org/gmane.linux.kernel/727133
[3] http://lkml.org/lkml/2008/11/20/171
