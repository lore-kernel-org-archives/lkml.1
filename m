Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZFXAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZFXAao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZFXAag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:30:36 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:45844 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFXAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:30:36 -0400
Date: Tue, 23 Jun 2009 17:28:55 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 updates for 2.6.31, take 2
Message-ID: <20090624002855.GA17214@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A4173A0.01B0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	Here are some more ocfs2 updates for 2.6.31.  More bug fixes,
mostly.  The one non-fix is lockdep annotation for ocfs2's cluster
locking.  Thanks to Jan Kara for that.  Please pull.

Joel

The following changes since commit 3fe0344faf7fdcb158bd5c1a9aec960a8d70c8e8:
  Linus Torvalds (1):
        Merge branch 'kmemleak' of git://linux-arm.org/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Jan Kara (2):
      vfs: Set special lockdep map for dirs only if not set by fs
      ocfs2: Add lockdep annotations

Joel Becker (1):
      ocfs2: Provide the ocfs2_dlm_lvb_valid() stack API.

Sunil Mushran (5):
      ocfs2: Pin journal head before accessing jh->b_committed_data
      ocfs2: Fix ocfs2_osb_dump()
      ocfs2: Stop orphan scan as early as possible during umount
      ocfs2: Do not initialize lvb in ocfs2_orphan_scan_lock_res_init()
      ocfs2: Disable orphan scanning for local and hard-ro mounts

Tao Ma (2):
      ocfs2: Update atime in splice read if necessary.
      ocfs2/trivial: Wrap ocfs2_sysfile_cluster_lock_key within define.

 fs/inode.c              |   17 ++++--
 fs/ocfs2/dlmglue.c      |  123 ++++++++++++++++++++++++++++++++++-------------
 fs/ocfs2/dlmglue.h      |   24 +++++++--
 fs/ocfs2/file.c         |    6 +-
 fs/ocfs2/inode.c        |   11 ++++
 fs/ocfs2/journal.c      |   43 +++++++++++-----
 fs/ocfs2/journal.h      |    2 +-
 fs/ocfs2/namei.c        |   15 ++++--
 fs/ocfs2/ocfs2.h        |   10 ++++
 fs/ocfs2/stack_o2cb.c   |   11 ++++
 fs/ocfs2/stack_user.c   |    8 +++
 fs/ocfs2/stackglue.c    |   13 +++--
 fs/ocfs2/stackglue.h    |    6 ++
 fs/ocfs2/suballoc.c     |   28 +++++++++--
 fs/ocfs2/super.c        |   69 ++++++++++++++-------------
 fs/ocfs2/sysfile.c      |   19 +++++++
 include/linux/lockdep.h |   15 ++++++
 17 files changed, 309 insertions(+), 111 deletions(-)

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
