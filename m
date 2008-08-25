Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYHYJRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYHYJRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYHYJRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:53150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYHYJRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET 1/3 blk-for-2.6.28] block: misc fixes and improvements
Date: Mon, 25 Aug 2008 18:15:35 +0900
Message-Id: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 09:16:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following five patches containing misc
fixes and improvements.

  0001-block-fix-partition-info-printouts.patch
  0002-block-don-t-grab-block_class_lock-unnecessarily.patch
  0003-block-use-class_dev_iterator-instead-of-class_for_e.patch
  0004-block-allow-deleting-zero-length-partition.patch
  0005-block-update-add_partition-error-handling.patch

Recent block_class iteration updates 5c6f35c5..27f3025 introduced a
few bugs and trivial user visible behavior change.  0001-0003 update
those issues and simplify related code using new class iterator.

0004 fixes deletion of zero sized partitions.

d805dda4 tried to fix error handling path in add_partition() but had a
few problems.  0005 fixes those and moves busy partition check into
add_partition().

This patchset is against

  blk-for-2.6.28 (9abd7c437c02e7448fb1d2d3cfc0b9c1ab77cf2d)
+ [1] klist-dont-iterate-over-deleted-entries
+ [2] use-klist-for-class-device-list-and-implement-iterator

and available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-misc-fixes
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-misc-fixes

with the following combined diffstat

 block/genhd.c         |  246 +++++++++++++++++++-------------------------------
 block/ioctl.c         |    9 -
 fs/partitions/check.c |   42 ++++----
 3 files changed, 121 insertions(+), 176 deletions(-)

Thanks.

--
tejun

[1] http://article.gmane.org/gmane.linux.kernel/725706
[2] http://article.gmane.org/gmane.linux.kernel/725708
