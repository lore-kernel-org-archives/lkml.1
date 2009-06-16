Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbZFPQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbZFPQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZFPQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:58:43 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:34850 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZFPQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:58:42 -0400
Date: Tue, 16 Jun 2009 09:57:32 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 updates for 2.6.31
Message-ID: <20090616165732.GA10257@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A37CF2C.00F0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	Here are the ocfs2 updates for 2.6.31.  It's a quiet cycle,
almost completely composed of fixes.  There is a nice performance
improvement from Hisashi Hifumi for fdatasync.  Please pull.

Joel


The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Coly Li (1):
      ocfs2: update comments in masklog.h

Hisashi Hifumi (1):
      ocfs2: fdatasync should skip unimportant metadata writeout

Jan Kara (5):
      ocfs2: Fix possible deadlock in ocfs2_global_read_dquot()
      ocfs2: Fix lock inversion in ocfs2_local_read_info()
      ocfs2: Fix possible deadlock with quotas in ocfs2_setattr()
      ocfs2: Fix possible deadlock in quota recovery
      ocfs2: Correct ordering of ip_alloc_sem and localloc locks for directories

Joel Becker (1):
      ocfs2: Add statistics for the checksum and ecc operations.

Srinivas Eeda (2):
      ocfs2: timer to queue scan of all orphan slots
      ocfs2 patch to track delayed orphan scan timer statistics

Sunil Mushran (1):
      ocfs2/net: Use wait_event() in o2net_send_message_vec()

Tao Ma (3):
      ocfs2: Don't printk the error when listing too many xattrs.
      ocfs2: Remove redundant gotos in ocfs2_mount_volume()
      ocfs2: Adjust rightmost path in ocfs2_add_branch.

 fs/ocfs2/alloc.c           |   80 ++++++++++++++++++-
 fs/ocfs2/blockcheck.c      |  184 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/blockcheck.h      |   29 +++++++-
 fs/ocfs2/cluster/masklog.h |   35 ++++----
 fs/ocfs2/cluster/tcp.c     |    7 +-
 fs/ocfs2/dir.c             |   21 +++---
 fs/ocfs2/dlmglue.c         |   51 ++++++++++++
 fs/ocfs2/dlmglue.h         |   11 +++
 fs/ocfs2/file.c            |   56 ++++++++------
 fs/ocfs2/journal.c         |  111 ++++++++++++++++++++++++++
 fs/ocfs2/journal.h         |    4 +
 fs/ocfs2/ocfs2.h           |   16 ++++
 fs/ocfs2/ocfs2_lockid.h    |    5 +
 fs/ocfs2/quota_global.c    |    4 +-
 fs/ocfs2/quota_local.c     |   21 ++++--
 fs/ocfs2/super.c           |   66 ++++++++++++----
 fs/ocfs2/xattr.c           |    5 +-
 17 files changed, 610 insertions(+), 96 deletions(-)

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
