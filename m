Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZLXCiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZLXCiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZLXCh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:37:59 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:37263 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZLXCh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:37:58 -0500
Date: Wed, 23 Dec 2009 18:36:09 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Sunil Mushran <sunil.mushran@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 updates for 2.6.33
Message-ID: <20091224023608.GA2196@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B32D3F9.0043:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,
	Here's the second set of changes.  This contains everything but
the conflicting patches.  Except for one thing, it contains small
feature and behavior tweaks for the filesystem.  We now default to
enabling ACLs like xfs and btrfs.  We add FIEMAP support for directories
and symlinks.
	The one change I'd like to call your attention to is the
FIEMAP_EXTENT_SHARED flag.  This is an addition to the general FIEMAP
ioctl.  It allows filesystems that can share a data extent between
inodes, like ocfs2 and btrfs, to note that fact in the FIEMAP result.
It is Acked-by: the original FIEMAP developer, Mark Fasheh.  Sunil
sent it out a number of times to the appropriate lists, trying to
determine which tree should send it your way and if anyone had
additional acks or naks, but he got no response.  I've included it
here.  If you would like additional acks or for it to go through a
different path, let me know; I'll drop it and resend the pull.
	Please pull.

Joel


The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 upstream-linus

Coly Li (2):
      ocfs2: explicit declare uninitialized var in user_cluster_connect()
      ocfs2: replace u8 by __u8 in ocfs2_fs.h

Jan Kara (3):
      ocfs2: Always include ACL support
      ocfs2: Make acl use the default
      ocfs2: Set MS_POSIXACL on remount

Jeff Liu (1):
      ocfs2-devel: remove redundant OCFS2_MOUNT_POSIX_ACL check in ocfs2_get_acl_nolock()

Joel Becker (1):
      ocfs2: Return -EINVAL when a device is not ocfs2.

Sunil Mushran (3):
      ocfs2/cluster: Make fence method configurable - v2
      fiemap: Add new extent flag FIEMAP_EXTENT_SHARED
      ocfs2: Use FIEMAP_EXTENT_SHARED

Tao Ma (4):
      ocfs2: Move ocfs2_complete_reflink to the right place.
      ocfs2: duplicate inline data properly during reflink.
      ocfs2/trivial: Use proper mask for 2 places in hearbeat.c
      ocfs2/trivial: Use le16_to_cpu for a disk value in xattr.c

Tiger Yang (1):
      ocfs2: return -EAGAIN instead of EAGAIN in dlm

Tristan Ye (2):
      Ocfs2: Should ocfs2 support fiemap for S_IFDIR inode?
      Ocfs2: Let ocfs2 support fiemap for symlink and fast symlink.

 fs/ocfs2/Kconfig               |   10 +---
 fs/ocfs2/Makefile              |    7 +--
 fs/ocfs2/acl.c                 |    4 --
 fs/ocfs2/acl.h                 |   22 --------
 fs/ocfs2/cluster/heartbeat.c   |    6 ++-
 fs/ocfs2/cluster/nodemanager.c |   51 ++++++++++++++++++
 fs/ocfs2/cluster/nodemanager.h |    7 +++
 fs/ocfs2/cluster/quorum.c      |   16 +++++-
 fs/ocfs2/dlm/dlmrecovery.c     |   18 +++---
 fs/ocfs2/extent_map.c          |   25 ++++++++--
 fs/ocfs2/file.c                |    3 +-
 fs/ocfs2/namei.c               |    1 +
 fs/ocfs2/ocfs2.h               |    8 ++-
 fs/ocfs2/ocfs2_fs.h            |    2 +-
 fs/ocfs2/refcounttree.c        |   69 +++++++++++++++++++++++--
 fs/ocfs2/stack_user.c          |    2 +-
 fs/ocfs2/super.c               |  111 ++++++++++++++++++++-------------------
 fs/ocfs2/symlink.c             |    2 +
 fs/ocfs2/xattr.c               |    6 +--
 fs/ocfs2/xattr.h               |    2 -
 include/linux/fiemap.h         |    2 +
 21 files changed, 245 insertions(+), 129 deletions(-)
-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
