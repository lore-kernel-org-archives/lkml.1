Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0CEQ23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:28:29 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:55228 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab0CEQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:28:28 -0500
Message-ID: <4B91317D.7000205@lougher.demon.co.uk>
Date: Fri, 05 Mar 2010 16:29:49 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: [GIT PULL V2] Squashfs updates for 2.6.34-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following revised Squashfs update for 2.6.34-rc1.
I have removed all the lzma/bunzip2/inflate/lzo code changes (which as far as I
know were the blocking issue previously).

What remains in the pull request is a clean-up/refactoring of the zlib
wrapper code, outline knowledge of lzma/lzo compressed filesystems (unsupported,
but it gives users an understandable error message when they try to mount them),
and some trivial code tidying.

Please pull.

Thanks

Phillip

-------------

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
   Linus Torvalds (1):
         Linux 2.6.33-rc4

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (6):
       Squashfs: move zlib decompression wrapper code into a separate file
       Squashfs: factor out remaining zlib dependencies into separate wrapper file
       Squashfs: add a decompressor framework
       Squashfs: add decompressor entries for lzma and lzo
       Squashfs: get rid of obsolete variable in struct squashfs_sb_info
       Squashfs: get rid of obsolete definition in header file

  fs/squashfs/Makefile         |    2 +-
  fs/squashfs/block.c          |   76 ++--------------------
  fs/squashfs/cache.c          |    1 -
  fs/squashfs/decompressor.c   |   68 +++++++++++++++++++
  fs/squashfs/decompressor.h   |   55 +++++++++++++++
  fs/squashfs/dir.c            |    1 -
  fs/squashfs/export.c         |    1 -
  fs/squashfs/file.c           |    1 -
  fs/squashfs/fragment.c       |    1 -
  fs/squashfs/id.c             |    1 -
  fs/squashfs/inode.c          |    1 -
  fs/squashfs/namei.c          |    1 -
  fs/squashfs/squashfs.h       |    8 ++-
  fs/squashfs/squashfs_fs.h    |    6 +-
  fs/squashfs/squashfs_fs_sb.h |   40 ++++++------
  fs/squashfs/super.c          |   49 +++++++-------
  fs/squashfs/symlink.c        |    1 -
  fs/squashfs/zlib_wrapper.c   |  150 ++++++++++++++++++++++++++++++++++++++++++
  18 files changed, 335 insertions(+), 128 deletions(-)
  create mode 100644 fs/squashfs/decompressor.c
  create mode 100644 fs/squashfs/decompressor.h
  create mode 100644 fs/squashfs/zlib_wrapper.c
