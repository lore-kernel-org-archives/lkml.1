Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab0BGIWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 03:22:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60245 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0BGIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:59 -0500
Date: Sun, 7 Feb 2010 08:21:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] VFS fixes for -rc8 (mostly IMA)
Message-ID: <20100207082158.GG30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes, mostly IMA ones.  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
(once it propagates, or from hera immediately)

Shortlog:
Al Viro (3):
      befs: fix leak
      Take ima_path_check() in nfsd past dentry_open() in nfsd_open()
      Take ima_file_free() to proper place.

Eric Paris (1):
      ima: initialize ima before inodes can be allocated

Jun'ichi Nomura (1):
      freeze_bdev: don't deactivate successfully frozen MS_RDONLY sb

Mimi Zohar (3):
      fix ima breakage
      ima: rename ima_path_check to ima_file_check
      ima: rename PATH_CHECK to FILE_CHECK

Diffstat:
 Documentation/ABI/testing/ima_policy |   12 +-
 fs/befs/linuxvfs.c                   |    1 +
 fs/block_dev.c                       |    7 +-
 fs/file_table.c                      |    1 +
 fs/namei.c                           |    6 +-
 fs/nfsd/vfs.c                        |    2 +-
 include/linux/ima.h                  |    4 +-
 init/main.c                          |    2 +-
 security/integrity/ima/ima.h         |    3 +-
 security/integrity/ima/ima_api.c     |    4 +-
 security/integrity/ima/ima_iint.c    |    9 +-
 security/integrity/ima/ima_main.c    |  239 +++++++++++++---------------------
 security/integrity/ima/ima_policy.c  |    9 +-
 security/security.c                  |    2 -
 14 files changed, 123 insertions(+), 178 deletions(-)
