Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXJLTfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXJLTfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXJLTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:35:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27316 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXJLTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:35:26 -0400
Date: Fri, 12 Oct 2007 12:34:45 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [git patches] ocfs2 updates
Message-ID: <20071012193445.GP30360@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the bulk of our ocfs2 changes for 2.6.24-rc1.

The biggest feature being added here is inline data support for Ocfs2. This
allows the file system to store file and directory data inside of the inode
block. Since Ocfs2 (like other similar cluster file systems) has rather
large inodes, this saves on space and improves performance on small files
and directories. Most of the patches in the inline-data seres are just
simple function moves or code refactors designed to allow the final
inline data patches to require very little in the way of code duplication.

Inline data is treated as a single contigous inode region starting at offset
0. Internally, the file system detects those inodes via an on-disk flag and
populates pages from their inode blocks. Writes go in the opposite
direction, with the exception that large writes force an inode out to
extents. For simplicity, shared writeable mmap and large extending truncates
also force the file out to extents.

The rest of the patches include:

 * ->show_options support
 * Various small cleanups

Thanks,
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c      |  482 ++++++++++++----
 fs/ocfs2/alloc.h      |    7 
 fs/ocfs2/aops.c       |  309 ++++++++++
 fs/ocfs2/aops.h       |    6 
 fs/ocfs2/dir.c        | 1423 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/dir.h        |   48 +
 fs/ocfs2/dlmglue.c    |    2 
 fs/ocfs2/dlmglue.h    |    4 
 fs/ocfs2/export.c     |    8 
 fs/ocfs2/extent_map.c |    6 
 fs/ocfs2/file.c       |  298 +++++-----
 fs/ocfs2/file.h       |    2 
 fs/ocfs2/inode.c      |    7 
 fs/ocfs2/inode.h      |    1 
 fs/ocfs2/journal.c    |  120 +---
 fs/ocfs2/journal.h    |    3 
 fs/ocfs2/namei.c      |  552 ++-----------------
 fs/ocfs2/namei.h      |   19 
 fs/ocfs2/ocfs2.h      |    7 
 fs/ocfs2/ocfs2_fs.h   |   64 ++
 fs/ocfs2/super.c      |   62 +-
 fs/ocfs2/sysfile.c    |   10 
 22 files changed, 2386 insertions(+), 1054 deletions(-)

Denis Cheng (1):
      fs/ocfs2/: removed unneeded initial value and function's return value

Mark Fasheh (19):
      ocfs2: Remove unused structure field
      ocfs2: Clear slot map when umounting a local volume
      ocfs2: Sync ocfs2_fs.h with ocfs2-tools
      ocfs2: move nonsparse hole-filling into ocfs2_write_begin()
      ocfs2: Small refactor of truncate zeroing code
      ocfs2: Move directory manipulation code into dir.c
      ocfs2: Abstract out core dir listing functionality
      ocfs2: Pass raw u64 to filldir
      ocfs2: Remove open coded readdir()
      ocfs2: Implement ocfs2_empty_dir() as a caller of ocfs2_dir_foreach()
      ocfs2: Provide convenience function for ino lookup
      ocfs2: Rename cleanups
      ocfs2: Cleanup dirent size check
      ocfs2: Structure updates for inline data
      ocfs2: Read support for inline data
      ocfs2: Write support for inline data
      ocfs2: Read support for directories with inline data
      ocfs2: Write support for directories with inline data
      ocfs2: Optionally return filldir errors

Sunil Mushran (1):
      ocfs2: Implement show_options()

Tao Mao (2):
      ocfs2: remove mostly unused field from insert structure
      ocfs2: remove unused variable
