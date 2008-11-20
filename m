Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYKTONP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYKTONP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYKTOMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:12:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:34822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbYKTOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:12:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Subject: [PATCHSET] FUSE: extend FUSE to support more operations, take #2
Date: Thu, 20 Nov 2008 23:11:33 +0900
Message-Id: <1227190298-4585-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:11:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, all.

This patchset is the second take of extend-FUSE patchset.  Changes
from the last take[L] are...

* add-include-protectors and implement-nonseekable-open already merged
  and thus dropped from this patchset.

* pass-nonblock-flag-to-client dropped in favor of fi.flags &
  O_NONBLOCK test.

* FUSE_MINOR moved to miscdevice.h

* ioctl support updated to include restricted mode where only well
  formed ioctls are supported and no retry is necesary or allowed.
  All FUSE servers are forced to use restricted mode ioctl.

* Per file unique kernel handle, fuse_file->kh, is added and used to
  match poll notification to its file.  This lifts the requirement
  that the FUSE server should supply unique fh to make use of poll.

* Other small fixes and updated to the current tree.

This patchset contains the following five patches.

 0001-fuse-move-FUSE_MINOR-to-miscdevice.h
 0002-FUSE-implement-ioctl-support
 0003-FUSE-add-file-kernel-handle
 0004-FUSE-implement-unsolicited-notification
 0005-FUSE-implement-poll-support

and is on top of

  master (ee2f6cc7f9ea2542ad46070ed62ba7aa04d08871)
+ [1] poll-allow-f_op_poll-to-sleep-take-2
+ [2] add-cdev_release-and-convert-cdev_alloc-to-use-it

This patchset is also available in the following git tree.

 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=extend-fuse
 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git extend-fuse

Combined diffstat follows.

 fs/fuse/dev.c              |   49 +++++
 fs/fuse/dir.c              |    2 
 fs/fuse/file.c             |  416 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/fuse_i.h           |   28 ++-
 fs/fuse/inode.c            |    2 
 include/linux/fuse.h       |   64 ++++++
 include/linux/miscdevice.h |   42 ++--
 7 files changed, 573 insertions(+), 30 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/727161
[1] http://lkml.org/lkml/2008/11/20/161
[2] http://article.gmane.org/gmane.linux.kernel/727133
