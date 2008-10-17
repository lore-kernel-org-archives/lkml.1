Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYJQRtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYJQRtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbYJQRtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:49:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:10485 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbYJQRtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FaRflHivPh0rmvsp0gTHBQWe4jETqydDjvOGm2UeOay3kz/9nPoAOhdSahDRO/9v/r
         GaqNkUlMf2Bg6AG30lqRpHTayq/NduDGZ4MMirRJ6m4Rdj/nwIKdHVzkO+yhhGyxSuVs
         3HlB0OSV7dey2+7v2+wEuU3IN9kYTIUPCBZBc=
Message-ID: <a4e6962a0810171049n29fb3136vba5e130cee33a3fd@mail.gmail.com>
Date: Fri, 17 Oct 2008 12:49:00 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] 9p patches for 2.6.28 merge window
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2e532d68a2b3e2aa6b19731501222069735c741c:
  Linus Torvalds (1):
        {pci,pnp} quirks.c: don't use deprecated print_fn_descriptor_symbol()

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-next

Eric Van Hensbergen (23):
      9p: consolidate transport structure
      9p: remove duplicate client state
      9p: remove unnecessary prototypes
      9p: consolidate mux_rpc and request structure
      9p: eliminate callback complexity
      9p: move request management to client code
      9p: apply common tagpool handling to trans_fd
      9p: apply common request code to trans_fd
      9p: use the rcall structure passed in the request in trans_fd read_work
      9p: make rpc code common and rework flush code
      9p: consolidate read/write functions
      9p: move readn meta-function from client to fs layer
      9p: adjust 9p vfs write operation
      9p: move dirread to fs layer
      9p: encapsulate version function
      9p: add new protocol support code
      9p: remove 9p fcall debug prints
      9p: remove unnecessary tag field from p9_req_t structure
      9p: rework client code to use new protocol support functions
      9p: eliminate depricated conv functions
      9p: Improve debug support
      9p: fix oops in protocol stat parsing error path.
      9p: add more conservative locking

Magnus Deininger (1):
      9p: fix device file handling

Tejun Heo (2):
      9p-trans_fd: use single poller
      9p: drop broken unused error path from p9_conn_create()

 fs/9p/v9fs.c               |    4 +-
 fs/9p/v9fs_vfs.h           |    6 +-
 fs/9p/vfs_addr.c           |    5 +-
 fs/9p/vfs_dir.c            |   60 ++-
 fs/9p/vfs_file.c           |   93 +++-
 fs/9p/vfs_inode.c          |   39 +-
 fs/9p/vfs_super.c          |    6 +-
 include/net/9p/9p.h        |  116 +---
 include/net/9p/client.h    |  124 ++++-
 include/net/9p/transport.h |   55 +--
 net/9p/Makefile            |    3 +-
 net/9p/client.c            | 1467 +++++++++++++++++++++++++-------------------
 net/9p/conv.c              | 1054 -------------------------------
 net/9p/fcprint.c           |  366 -----------
 net/9p/mod.c               |    1 +
 net/9p/protocol.c          |  558 +++++++++++++++++
 net/9p/protocol.h          |   34 +
 net/9p/trans_fd.c          | 1431 ++++++++++++++-----------------------------
 net/9p/trans_virtio.c      |  246 ++-------
 net/9p/util.c              |    4 +
 20 files changed, 2223 insertions(+), 3449 deletions(-)
 delete mode 100644 net/9p/conv.c
 delete mode 100644 net/9p/fcprint.c
 create mode 100644 net/9p/protocol.c
 create mode 100644 net/9p/protocol.h
