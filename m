Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbYBGBjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbYBGBjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYBGBj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:39:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:29392 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYBGBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:39:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=u0yEX9K5Ub9KCgImO3zDxo94d1sDrtO1vESg9+r42gWh6bXmYCUpR+Vn+wuP9DeezpMqlwWOo7Kw0IAp4o8j8TxErRJ7egd/xwhJnrvIEMSdxDPWRJnhlwys2vyoPrkBBWa20DgqmYJevnslG5+mTUuGEal0sK1dV3AaepOhnbo=
Message-ID: <a4e6962a0802061739v6280c3acw1a7da77991037824@mail.gmail.com>
Date: Wed, 6 Feb 2008 19:39:26 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org
Subject: [PULL] v9fs patches for merge window
Cc: "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3e6bdf473f489664dac4d7511d26c7ac3dfdc748:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../x86/linux-2.6-x86

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git

Andrew Morton (1):
      9p: fix p9_printfcall export

Anthony Liguori (2):
      9p: add support for sticky bit
      9p: Convert semaphore to spinlock for p9_idpool

Eric Van Hensbergen (7):
      9p: create transport rpc cut-thru
      9p: block-based virtio client
      9p: fix bug in attach-per-user
      9p: Fix soft lockup in virtio transport
      9p: fix mmap to be read-only
      9p: add remove function to trans_virtio
      9p: transport API reorganization

Martin Stava (1):
      9p: fix bug in p9_clone_stat

 fs/9p/fid.c                |    4 +-
 fs/9p/v9fs.c               |   51 +--
 fs/9p/v9fs.h               |    5 +-
 fs/9p/vfs_file.c           |    4 +-
 fs/9p/vfs_inode.c          |    5 +
 include/net/9p/9p.h        |    1 +
 include/net/9p/client.h    |    5 +-
 include/net/9p/conn.h      |   57 ---
 include/net/9p/transport.h |   11 +-
 net/9p/Makefile            |    1 -
 net/9p/client.c            |  161 +++++--
 net/9p/fcprint.c           |    4 +-
 net/9p/mod.c               |    9 +-
 net/9p/mux.c               | 1060 ------------------------------------------
 net/9p/trans_fd.c          | 1103 +++++++++++++++++++++++++++++++++++++++++++-
 net/9p/trans_virtio.c      |  355 +++++++++------
 net/9p/util.c              |   20 +-
 17 files changed, 1466 insertions(+), 1390 deletions(-)
 delete mode 100644 include/net/9p/conn.h
 delete mode 100644 net/9p/mux.c
