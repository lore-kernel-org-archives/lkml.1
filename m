Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZCEQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZCEQLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZCEQLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:11:19 -0500
Received: from sh.osrg.net ([192.16.179.4]:40819 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZCEQLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:11:18 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm 0/5] nilfs2 settle matters related to disk format
Date: Fri,  6 Mar 2009 01:07:44 +0900
Message-Id: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Mar 2009 01:11:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This additional series is for stabilizing the current disk format.
This will

* fix a recently found endian bug
* clean up an obsolete posix-noncompliant file.
* apply simplification which involves removal of an on-disk flag.
* add an on-disk flag required by applications managing checkpoints, and
* introduce secondary super block for reliability improvement

The first bugfix once breaks compatibility on big endian machines, but
it's needed to eliminate the architecture dependency.  A remedy for
this defect is just mounting the old partition (created by big endian
machine) with the version applied the first patch.  The latest release
of out-of-tree module (e.g. nilfs-2.0.9 available from
http://www.nilfs.org/en/ ) can serve for the purpose.  Little endian
architectures, incidentally, are not affected by the bug.

The remaining patches keep compatibility though a few of them have
minute differences in disk format declarations (i.e. nilfs2_fs.h).

Xattr, posix-acl, atime, are not yet supported, but preparations to
keep backward compatibility are included.  I'm reviewing user's
feedbacks to find out other problems which may impact on the
compatibility.  Hopefully, this series would help to avoid future
confusion.

The corresponding userland package (nilfs-utils) is available from
the git repo in the following site:

  http://www.nilfs.org/git/

Regards,
Ryusuke Konishi
---
 Documentation/filesystems/nilfs2.txt |    2 -
 fs/nilfs2/inode.c                    |   35 +-----
 fs/nilfs2/nilfs.h                    |    7 +-
 fs/nilfs2/recovery.c                 |   13 +--
 fs/nilfs2/segbuf.c                   |   24 +----
 fs/nilfs2/segbuf.h                   |    6 +-
 fs/nilfs2/segment.c                  |  239 ++++------------------------------
 fs/nilfs2/segment.h                  |   18 +--
 fs/nilfs2/sufile.c                   |    8 +-
 fs/nilfs2/super.c                    |  231 ++++++++++++++-------------------
 fs/nilfs2/the_nilfs.c                |  179 ++++++++++++++++++++++----
 fs/nilfs2/the_nilfs.h                |   23 +++-
 include/linux/nilfs2_fs.h            |    9 +-
 13 files changed, 319 insertions(+), 475 deletions(-)


