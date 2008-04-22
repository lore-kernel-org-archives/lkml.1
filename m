Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbYDVKFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbYDVKFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759653AbYDVKFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:05:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:39612 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753550AbYDVKFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:05:40 -0400
Date: Tue, 22 Apr 2008 12:05:38 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] UDF updates for 2.6.26-rc1
Message-ID: <20080422100538.GA22899@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

  would you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get various UDF cleanups, fixes and read-only support for UDF 2.60
(used on BlueRay media). Diffstat and shortlog is below. Thanks.

									Honza

 fs/Kconfig                |    1 +
 fs/udf/Makefile           |    2 +-
 fs/udf/balloc.c           |   13 +-
 fs/udf/crc.c              |  172 ------
 fs/udf/dir.c              |   83 +--
 fs/udf/ecma_167.h         |   13 -
 fs/udf/file.c             |   47 --
 fs/udf/ialloc.c           |   13 +-
 fs/udf/inode.c            |  208 +++------
 fs/udf/lowlevel.c         |    1 -
 fs/udf/misc.c             |   26 +-
 fs/udf/namei.c            |  218 +++-----
 fs/udf/partition.c        |   67 +++-
 fs/udf/super.c            | 1262 ++++++++++++++++++++++++---------------------
 fs/udf/symlink.c          |    1 -
 fs/udf/truncate.c         |   81 ++--
 fs/udf/udf_i.h            |   30 +-
 fs/udf/udf_sb.h           |  109 ++++-
 fs/udf/udfdecl.h          |   67 ++-
 fs/udf/udfend.h           |   22 -
 fs/udf/udftime.c          |   35 +-
 fs/udf/unicode.c          |   62 +--
 include/linux/Kbuild      |    2 +-
 include/linux/udf_fs.h    |   51 --
 include/linux/udf_fs_i.h  |   31 --
 include/linux/udf_fs_sb.h |  117 -----
 26 files changed, 1173 insertions(+), 1561 deletions(-)

Adrian Bunk (1):
      make udf_error() static

Bob Copeland (1):
      udf: use crc_itu_t from lib instead of udf_crc

Christoph Hellwig (3):
      udf: kill udf_set_blocksize
      udf: kill useless file header comments for vfs method implementations
      udf: move headers out include/linux/

Jan Kara (15):
      udf: Mark udf_process_sequence() as noinline
      udf: Remove checking of existence of filename in udf_add_entry()
      udf: Remove declarations of arrays of size UDF_NAME_LEN (256 bytes)
      udf: Cleanup volume descriptor sequence processing
      udf: Improve error recovery on mount
      udf: Move filling of partition descriptor info into a separate function
      udf: Move processing of virtual partitions
      udf: Cleanup anchor block detection.
      udf: Improve anchor block detection
      udf: Silence warning about accesses beyond end of device
      udf: Fix detection of VAT version
      udf: Allow loading of VAT inode
      udf: Handle VAT packed inside inode properly
      udf: Mount filesystem read-only if it has pseudooverwrite partition
      udf: Add read-only support for 2.50 UDF media

Julia Lawall (1):
      fs/udf: Use DIV_ROUND_UP

Marcin Slusarz (5):
      udf: fix udf_build_ustr
      udf: convert udf_count_free_bitmap to use bitmap_weight
      udf: convert udf_stamp_to_time and udf_time_to_stamp to use timestamps
      udf: remove unneeded kernel_timestamp type
      udf: super.c reorganization

Pavel Emelyanov (1):
      udf: fix anchor point detection

Sebastian Manciulea (3):
      udf: Fix handling of multisession media
      udf: Fix bug in VAT mapping code
      udf: Fix compilation warnings when UDF debug is on

marcin.slusarz@gmail.com (11):
      udf: udf_CS0toUTF8 cleanup
      udf: udf_CS0toNLS cleanup
      udf: constify crc
      udf: simple cleanup of truncate.c
      udf: truncate: create function for updating of Allocation Ext Descriptor
      udf: replace all adds to little endians variables with le*_add_cpu
      udf: simplify __udf_read_inode
      udf: replace udf_*_offset macros with functions
      udf: udf_get_block, inode_bmap - remove unneeded checks
      udf: create function for conversion from timestamp to timespec
      udf: convert udf_stamp_to_time to return struct timespec

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
