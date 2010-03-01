Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0CATk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:40:27 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:52310 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab0CATkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:40:25 -0500
Message-ID: <4B8C1873.1080700@lougher.demon.co.uk>
Date: Mon, 01 Mar 2010 19:41:39 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Squashfs updates for 2.6.34
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Squashfs updates.  They add support
for lzma compressed file systems, plus there's also a couple of
trivial code tidy patches.

Thanks

Phillip


-------

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
   Linus Torvalds (1):
         Linux 2.6.33-rc4

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (11):
       Squashfs: move zlib decompression wrapper code into a separate file
       Squashfs: factor out remaining zlib dependencies into separate wrapper file
       Squashfs: add a decompressor framework
       Squashfs: add decompressor entries for lzma and lzo
       Squashfs: add support for LZMA compressed filesystems
       lzma: Make lzma available to non initramfs/initrd code
       Squashfs: select DECOMPRESS_LZMA_NEEDED when including support for lzma
       lzma: make lzma reentrant
       Squashfs: get rid of obsolete variable in struct squashfs_sb_info
       Squashfs: get rid of obsolete definition in header file
       Squashfs: update Kconfig help to include lzma support

Randy Dunlap (1):
       libs: force lzma_wrapper to be retained

  fs/squashfs/Kconfig                   |   23 +++--
  fs/squashfs/Makefile                  |    3 +-
  fs/squashfs/block.c                   |   76 +---------------
  fs/squashfs/cache.c                   |    1 -
  fs/squashfs/decompressor.c            |   72 ++++++++++++++++
  fs/squashfs/decompressor.h            |   55 ++++++++++++
  fs/squashfs/dir.c                     |    1 -
  fs/squashfs/export.c                  |    1 -
  fs/squashfs/file.c                    |    1 -
  fs/squashfs/fragment.c                |    1 -
  fs/squashfs/id.c                      |    1 -
  fs/squashfs/inode.c                   |    1 -
  fs/squashfs/lzma_wrapper.c            |  151 +++++++++++++++++++++++++++++++++
  fs/squashfs/namei.c                   |    1 -
  fs/squashfs/squashfs.h                |   11 ++-
  fs/squashfs/squashfs_fs.h             |    6 +-
  fs/squashfs/squashfs_fs_sb.h          |   40 +++++-----
  fs/squashfs/super.c                   |   49 ++++++-----
  fs/squashfs/symlink.c                 |    1 -
  fs/squashfs/zlib_wrapper.c            |  150 ++++++++++++++++++++++++++++++++
  include/linux/decompress/bunzip2_mm.h |   13 +++
  include/linux/decompress/inflate_mm.h |   13 +++
  include/linux/decompress/mm.h         |    4 -
  include/linux/decompress/unlzma_mm.h  |   20 +++++
  include/linux/decompress/unlzo_mm.h   |   13 +++
  lib/Kconfig                           |    3 +
  lib/Makefile                          |    2 +-
  lib/decompress_bunzip2.c              |    1 +
  lib/decompress_inflate.c              |    1 +
  lib/decompress_unlzma.c               |   88 ++++++++++---------
  lib/decompress_unlzo.c                |    1 +
  31 files changed, 621 insertions(+), 183 deletions(-)
  create mode 100644 fs/squashfs/decompressor.c
  create mode 100644 fs/squashfs/decompressor.h
  create mode 100644 fs/squashfs/lzma_wrapper.c
  create mode 100644 fs/squashfs/zlib_wrapper.c
  create mode 100644 include/linux/decompress/bunzip2_mm.h
  create mode 100644 include/linux/decompress/inflate_mm.h
  create mode 100644 include/linux/decompress/unlzma_mm.h
  create mode 100644 include/linux/decompress/unlzo_mm.h
