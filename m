Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZDNCGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZDNCGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZDNCFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:05:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:34459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZDNCFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:05:46 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: [PATCHSET] FUSE: implement direct mmap, take#2
Date: Tue, 14 Apr 2009 11:04:17 +0900
Message-Id: <1239674662-31318-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 02:04:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos, Nick, Andrew.

This is the second take of fuse-implement-direct-mmap patchset.  This
patchset implements direct mmap support for FUSE (and CUSE).  Each
direct mmap area is backed by anonymous mapping (shmem_file) and the
FUSE server can decide how they are shared.

mmap request is handled in two steps.  MMAP first queries the server
whether it wants to share the mapping with an existing one or create a
new one, and if so, with which flags.  MMAP_COMMIT notifies the server
the result of mmap and if successful the fd the server can use to
access the mmap region.

Changes from the last take[L] are

* 0003-FUSE-don-t-let-fuse_req-end-put-the-base-referen.patch was
  merged and thus dropped from this series.

* Updated to the current master + implement-cuse, take#3.

This patchset contains the following patches.

  0001-mmap-don-t-assume-f_op-mmap-doesn-t-change-vma.patch
  0002-fdtable-export-alloc_fd.patch
  0003-FUSE-make-request_wait_answer-wait-for-end-co.patch
  0004-FUSE-implement-fuse_req-prep.patch
  0005-FUSE-implement-direct-mmap.patch

0001-0002 update mm and fdtable for following FUSE changes.  0003-0004
update fuse_req->end() handling and add ->prep().  0005 implements
direct mmap.

Nick, Andrew, can you guys please review and ack 0001-0002?

This patchset is on top of

  linus#master(80a04d3f2f94fb68b5df05e3ac6697130bc3467a)
+ [1] implement-cuse patchset, take#3

and is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git fuse-mmap

diffstat follows.

 fs/file.c            |    1 
 fs/fuse/cuse.c       |    1 
 fs/fuse/dev.c        |   70 ++++++--
 fs/fuse/file.c       |  424 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h     |   19 ++
 include/linux/fuse.h |   47 +++++
 mm/mmap.c            |    1 
 7 files changed, 533 insertions(+), 30 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.comp.file-systems.fuse.devel/7212
[1] http://thread.gmane.org/gmane.comp.file-systems.fuse.devel/7705
