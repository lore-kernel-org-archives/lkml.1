Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYEOCUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYEOCUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYEOCUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:20:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:54431 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYEOCUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QzosIWwxuUPGI0/XSML4fJ/BIUnmqvfEXY1iA9xMuPsSZH1YEBpzDoKgOd0Ie0s/5sZeUbnWkF+kO8PXKYmkVVXDkKRHdlEolt1iQv+SmpKSaZ+EzOwYPz2LzMTTdByfHuc/eXzv9c7e/8+sZ73V+QrrONnkoL1x6TA3XXZSfOQ=
Message-ID: <a4e6962a0805141920x7d96df33gb9c22a5777b1732c@mail.gmail.com>
Date: Wed, 14 May 2008 21:20:21 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [PULL] v9fs bug fixes and documentation updates for 2.6.26
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following bug-fixes and documentation updates
from my kernel.org for-linus branch.

The following changes since commit dd286422fefdcff784e8d336deeb88ce817e14db:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Eric Van Hensbergen (4):
      9p: Documentation updates
      9p: propagate parse_option changes to client and transports
      9p: make cryptic unknown error from server less scary
      9p: fix error path during early mount

Jim Meyering (1):
      fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and
match_strdup failure. Now that this function can fail, return an int,
diagnose other option-parsing failures, and adjust the sole caller:
(v9fs_session_init): Handle kstrdup failure. Propagate any new
v9fs_parse_options failure "up".

Josef 'Jeff' Sipek (2):
      9p: use struct mutex instead of struct semaphore
      9p: Correct fidpool creation failure in p9_client_create

Markus Armbruster (1):
      add match_strlcpy() us it to make v9fs make uname and remotename
parsing more robust

Steven Rostedt (1):
      9p: fix flags length in net

 fs/9p/fid.h                |   15 +++
 fs/9p/v9fs.c               |   57 ++++++++---
 fs/9p/v9fs.h               |   85 +++++++++++-----
 fs/9p/vfs_addr.c           |    2 +-
 fs/9p/vfs_dir.c            |    2 +-
 fs/9p/vfs_file.c           |   11 +-
 fs/9p/vfs_inode.c          |   50 +++++++---
 fs/9p/vfs_super.c          |   35 +++----
 include/linux/parser.h     |    2 +-
 include/net/9p/9p.h        |  240 ++++++++++++++++++++++++++++++++++++++------
 include/net/9p/client.h    |   35 +++++++
 include/net/9p/transport.h |   44 ++++++++-
 lib/parser.c               |   32 ++++--
 net/9p/Kconfig             |   10 --
 net/9p/Makefile            |    3 -
 net/9p/client.c            |   32 +++++--
 net/9p/conv.c              |  128 +++++++++++++++++++++++-
 net/9p/error.c             |   15 ++-
 net/9p/fcprint.c           |    8 ++
 net/9p/mod.c               |    8 +-
 net/9p/trans_fd.c          |  204 +++++++++++++++++++++++++++++++-------
 net/9p/trans_virtio.c      |  175 ++++++++++++++++++++++++++++----
 net/9p/util.c              |   36 +++++--
 23 files changed, 1014 insertions(+), 215 deletions(-)
