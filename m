Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbZFLMos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbZFLMos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759306AbZFLMok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:44:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34016 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920AbZFLMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:44:38 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, tj@kernel.org, akpm@linux-foundation.org
Subject: [GIT PULL] Add Character device in Userspace (CUSE) support
Message-Id: <E1MF67V-0001H7-Sb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 12 Jun 2009 14:44:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the 'cuse' branch of the fuse tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git cuse

This adds support for character device emulation in userspace with the
help of already existing fuse infrastructure.  It was mostly
implemented by Tejun, including OSSP (an OSS emulation layer using
Pulse Audio) which makes use of this feature.

Thanks,
Miklos

---
Miklos Szeredi (10):
      fuse: use struct path in release structure
      fuse: clean up fuse_write_fill()
      fuse: prepare fuse_direct_io() for CUSE
      fuse: add members to struct fuse_file
      fuse: don't use inode in helpers called by fuse_direct_io()
      fuse: clean up args in fuse_finish_open() and fuse_release_fill()
      fuse: create fuse_do_open() helper for CUSE
      fuse: don't use inode in fuse_sync_release()
      fuse: don't use inode in fuse_do_ioctl() helper
      fuse: don't use inode in fuse_file_poll

Tejun Heo (4):
      fuse: misc cleanups
      fuse: update fuse_conn_init() and separate out fuse_conn_kill()
      fuse: export symbols to be used by CUSE
      CUSE: implement CUSE - Character device in Userspace

---
 fs/Kconfig           |   10 +
 fs/fuse/Makefile     |    1 +
 fs/fuse/cuse.c       |  610 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev.c        |   15 +-
 fs/fuse/dir.c        |   33 +--
 fs/fuse/file.c       |  346 +++++++++++++++++------------
 fs/fuse/fuse_i.h     |   47 +++-
 fs/fuse/inode.c      |  118 ++++++----
 include/linux/fuse.h |   31 +++
 9 files changed, 980 insertions(+), 231 deletions(-)
 create mode 100644 fs/fuse/cuse.c
