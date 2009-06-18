Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZFRJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZFRJ0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZFRJ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:26:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbZFRJ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:26:05 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: [PATCHSET] FUSE/CUSE: implement direct mmap, take#3
Date: Thu, 18 Jun 2009 18:24:29 +0900
Message-Id: <1245317073-24000-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 09:24:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the third take of fuse-implement-direct-mmap patchset.  This
patchset implements direct mmap support for FUSE (and CUSE).  Each
direct mmap area is backed by anonymous mapping (shmem_file) and the
FUSE server can decide how they are shared.

mmap request is handled in two steps.  MMAP first queries the server
whether it wants to share the mapping with an existing one or create a
new one, and if so, with which flags.  MMAP_COMMIT notifies the server
the result of mmap and if successful the fd the server can use to
access the mmap region.

Changes from the last take[L] are

* mmap-don-t-assume-f_op-mmap-doesn-t-change-vma.patch was
  unnecessary.  Dropped and mmap implementation updated accordingly.

* Updated to the current master which now contains CUSE support.

This patchset contains the following patches.

  0001-fdtable-export-alloc_fd.patch
  0002-FUSE-make-request_wait_answer-wait-for-end-co.patch
  0003-FUSE-implement-fuse_req-prep.patch
  0004-FUSE-implement-direct-mmap.patch

0001 update exports fdtable for following FUSE changes.  0002-0003
update fuse_req->end() handling and add ->prep().  0004 implements
direct mmap.

This patchset is on top of

  linus#master(1d89b30cc9be41af87881682ec82e2c107849dbe)

and is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git fuse-mmap

diffstat follows.

 fs/file.c            |    1 
 fs/fuse/cuse.c       |    1 
 fs/fuse/dev.c        |   70 ++++++--
 fs/fuse/file.c       |  432 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h     |   19 ++
 include/linux/fuse.h |   47 +++++
 6 files changed, 538 insertions(+), 32 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/821839
