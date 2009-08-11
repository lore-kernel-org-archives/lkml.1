Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZHKScM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZHKScM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZHKScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:32:11 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:32657 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZHKScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:32:10 -0400
Date: Tue, 11 Aug 2009 11:31:34 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 fixes for 2.6.31-rc5
Message-ID: <20090811183134.GA28478@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A81B919.0092:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	Here are all the outstanding ocfs2 fixes for 2.6.31.  The major
fixes are for aio write and for non-sparse file extending.  There are
also a couple of b-tree fixes as well as some for quotas.
	Please pull.

Joel

The following changes since commit 44b572809581d5a10dbe35aa6bf689f32b9c5ad6:
  Yinghai Lu (1):
        x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa is not compiled in

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Goldwyn Rodrigues (2):
      ocfs2: Initialize count in aio_write before generic_write_checks
      ocfs2: Remove redundant BUG_ON in __dlm_queue_ast()

Jan Kara (9):
      ocfs2: Fix deadlock on umount
      ocfs2: Make global quota files blocksize aligned
      ocfs2: Mark buffer uptodate before calling ocfs2_journal_access_dq()
      ocfs2: Initialize blocks allocated to local quota file
      ocfs2: Zero out padding of on disk dquot structure
      ocfs2: Fix initialization of blockcheck stats
      ocfs2: Remove syncjiff field from quota info
      ocfs2: Define credit counts for quota operations
      ocfs2: Fix possible deadlock when extending quota file

Jeff Liu (1):
      ocfs2: trivial fix for s/migrate/migration/ in dlmrecovery.c logging

Jeff Mahoney (1):
      ocfs2: Fixup orphan scan cleanup after failed mount

Roel Kluin (1):
      ocfs2: keep index within status_map[]

Subrata Modak (1):
      ocfs2: Fix compilation warning for fs/ocfs2/xattr.c

Sunil Mushran (1):
      ocfs2: Initialize the cluster we're writing to in a non-sparse extend

Tao Ma (3):
      ocfs2: Add extra credits and access the modified bh in update_edge_lengths.
      ocfs2: Use ocfs2_rec_clusters in ocfs2_adjust_adjacent_records.
      ocfs2/quota: Release lock for error in ocfs2_quota_write.

Wengang Wang (3):
      ocfs2: log the actual return value of ocfs2_file_aio_write()
      ocfs2: Fix error return in ocfs2_write_cluster()
      ocfs2: Fail ocfs2_get_block() immediately when a block needs allocation

 fs/ocfs2/alloc.c           |   47 +++++++++++++--
 fs/ocfs2/aops.c            |   69 ++++++++++++++++-------
 fs/ocfs2/dcache.c          |   35 +++++++++---
 fs/ocfs2/dcache.h          |    3 +
 fs/ocfs2/dlm/dlmast.c      |    1 -
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 fs/ocfs2/file.c            |    5 +-
 fs/ocfs2/journal.c         |    8 ++-
 fs/ocfs2/journal.h         |   19 ++++---
 fs/ocfs2/ocfs2.h           |   22 ++++++-
 fs/ocfs2/quota.h           |    1 -
 fs/ocfs2/quota_global.c    |  134 +++++++++++++++++++++++--------------------
 fs/ocfs2/quota_local.c     |  110 +++++++++++++++++++++++++++++++-----
 fs/ocfs2/stack_o2cb.c      |    3 +-
 fs/ocfs2/super.c           |   30 +++++++++-
 fs/ocfs2/xattr.c           |    3 +-
 16 files changed, 357 insertions(+), 135 deletions(-)
-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
