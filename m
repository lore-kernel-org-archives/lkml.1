Return-Path: <linux-kernel-owner+w=401wt.eu-S1764673AbXGNUUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764673AbXGNUUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbXGNUUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:20:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbXGNUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ck/zs93600rpA/cVhxkJ1u+TsXOD6CCBsMzvJNR/JmcuS886vm2qSwlFdj9GJLyG5A/ME8qgYzqZoQSWJtTs0BK/bCssU3ZGT4KYrseFSRMwB9MRYJIdv3Xp2LfvYbGM2GF2cpVWzFEUJvJJm+pWm2X2psBX5cP2rIWT8RP889g=
Message-ID: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com>
Date: Sat, 14 Jul 2007 15:20:11 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org
Subject: [GIT PULL] 9p Patches for 2.6.23 merge window
Cc: "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Latchesar Ionkov(3):
  Reorganization of 9p file system code
  Change net/9p module name to 9pnet
  Set error to EREMOTEIO if transport write returns zero

Eric Van Hensbergen(3)
  Cache meta-data when loose cache option is set
  Renable mount-time debug option
  Fix a race condition bug in umount which caused segfault

The bulk of the changes were in the reorganization patch which mostly
moved files and interfaces around in preparation for work on an
in-kernel 9p server.

 b/fs/9p/Makefile             |    6
 b/fs/9p/fid.c                |  168 ++----
 b/fs/9p/fid.h                |   43 -
 b/fs/9p/v9fs.c               |  288 ++---------
 b/fs/9p/v9fs.h               |   32 -
 b/fs/9p/v9fs_vfs.h           |    6
 b/fs/9p/vfs_addr.c           |   57 --
 b/fs/9p/vfs_dentry.c         |   37 -
 b/fs/9p/vfs_dir.c            |  155 +-----
 b/fs/9p/vfs_file.c           |  160 +-----
 b/fs/9p/vfs_inode.c          |  753 +++++++++++-------------------
 b/fs/9p/vfs_super.c          |   91 +--
 b/fs/Kconfig                 |    2
 b/include/net/9p/9p.h        |  417 +++++++++++++++++
 b/include/net/9p/client.h    |   80 +++
 b/include/net/9p/conn.h      |   57 ++
 b/include/net/9p/transport.h |   49 ++
 b/net/9p/Kconfig             |   21
 b/net/9p/Makefile            |   13
 b/net/9p/client.c            |  965 +++++++++++++++++++++++++++++++++++++++
 b/net/9p/conv.c              |  903 ++++++++++++++++++++++++++++++++++++
 b/net/9p/error.c             |  240 +++++++++
 b/net/9p/fcprint.c           |  358 ++++++++++++++
 b/net/9p/mod.c               |   85 +++
 b/net/9p/mux.c               | 1050 +++++++++++++++++++++++++++++++++++++++++++
 b/net/9p/sysctl.c            |   86 +++
 b/net/9p/trans_fd.c          |  363 ++++++++++++++
 b/net/9p/util.c              |  125 +++++
 b/net/Kconfig                |    1
 b/net/Makefile               |    2
 fs/9p/9p.h                   |  375 ---------------
 fs/9p/conv.c                 |  845 ----------------------------------
 fs/9p/conv.h                 |   50 --
 fs/9p/debug.h                |   77 ---
 fs/9p/error.c                |   93 ---
 fs/9p/error.h                |  177 -------
 fs/9p/fcall.c                |  427 -----------------
 fs/9p/fcprint.c              |  345 --------------
 fs/9p/mux.c                  | 1033 ------------------------------------------
 fs/9p/mux.h                  |   55 --
 fs/9p/trans_fd.c             |  308 ------------
 fs/9p/transport.h            |   45 -
 fs/9p/v9fs.c                 |    7
 fs/9p/vfs_file.c             |   14
 fs/9p/vfs_inode.c            |    4
 fs/9p/vfs_super.c            |    3
 net/9p/Makefile              |    7
 net/9p/client.c              |    7
 net/9p/mux.c                 |    7
 49 files changed, 5400 insertions(+), 5092 deletions(-)
