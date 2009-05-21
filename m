Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZEUJXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZEUJXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZEUJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:23:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50312 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZEUJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:23:06 -0400
Message-Id: <20090521092231.979256687@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 21 May 2009 11:22:31 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk
Subject: [patch 0/5] union-directory implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements the simplest form of union mounts (called
union directories here).  This is somewhat similar to Plan9 union
mounts.  The patches are derived from Jan Blunck's work.

Also available from git:
  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git union-dir

Features:

 - top level directory unification only
 - no copy up
 - no whiteouts, opaque dir, etc...
 - create/rename/unlink only work on top layer
 - write works on any layer (without copy up)
 - directory entry deduplication in kernel
 - supports directory seeking (that hell from POSIX)

Shortcomings:

 - directory reading is O(n^2), needs optimization
 - weird create/unlink semantics due to ignoring union

I'm posting these patches in a hope that

 a) they may be useful on their own (after further development),
 b) they may help with the full fledged union-mount implementation

Comments?

Thanks,
Miklos
--

Jan Blunck (5):
      union-directory: Introduce MNT_UNION and MS_UNION flags
      union-directory: Support for traversing the layers of a union-directory
      union-directory: Some checks during namespace changes
      union-directory: Make lookup continue in overlayed directories
      union-directory: Simple union-mount readdir implementation

---
 fs/Kconfig            |    8 ++
 fs/Makefile           |    2 +
 fs/file_table.c       |    1 +
 fs/namei.c            |   49 +++++++++++
 fs/namespace.c        |   25 +++++-
 fs/readdir.c          |   21 +++--
 fs/union.c            |  229 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h            |   26 ++++++
 include/linux/fs.h    |   18 ++++
 include/linux/mount.h |    1 +
 10 files changed, 369 insertions(+), 11 deletions(-)
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h
