Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYDWVdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYDWVdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYDWVdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:33:43 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46695 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYDWVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:33:41 -0400
Date: Wed, 23 Apr 2008 17:33:37 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: nfsd changes for 2.6.26
Message-ID: <20080423213337.GG8302@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following nfsd-related changes are available from the for-linus
branch of the git repository at:

  git://linux-nfs.org/~bfields/linux.git for-linus

Nothing earth-shattering; mostly miscellaneous bugfixes and cleanup, for
lockd and nfsd.

Jeff Layton's conversion of lockd and the NFSv4 callback server to
kthreads is one of the larger pieces, Chuck did a bunch of kconfig
cleanup, etc.

--b.

Adrian Bunk (1):
      make nfsd_create_setattr() static

Andrew Morton (1):
      net/sunrpc/svc.c: suppress unintialized var warning

Aurélien Charbon (1):
      IPv6 support for NFS server export caches

Chuck Lever (12):
      NFSD: Remove NFSD_TCP kernel build option
      NFSD: Update help text for CONFIG_NFSD
      NFSD: Move "select FS_POSIX_ACL if NFSD_V4"
      NFSD: Move "select NFSD_V2_ACL if NFSD_V3_ACL"
      NFSD: Remove redundant "select" clauses in fs/Kconfig
      NFSD: Use "depends on" for PROC_FS dependency
      SUNRPC: Remove PROC_FS dependency
      NFSD: Remove NFSv4 dependency on NFSv3
      SUNRPC: RPC server still uses 2.4 method for disabling TCP Nagle
      SUNRPC: Update RPC server's TCP record marker decoder
      SUNRPC: Use unsigned index when looping over arrays
      SUNRPC: Use unsigned loop and array index in svc_init_buffer()

Felix Blyakher (1):
      nfsd: initialize lease type in nfs4_open_delegation()

Harshula Jayasuriya (1):
      sunrpc: GSS integrity and decryption failures should return GARBAGE_ARGS

Harvey Harrison (3):
      lockd: fix sparse warning in svcshare.c
      nfsd: fix sparse warnings
      nfsd: fix sparse warning in vfs.c

J. Bruce Fields (12):
      nfs: remove unnecessary NFS_NEED_* defines
      nfsd4: remove unnecessary CHECK_FH check in preprocess_seqid_op
      nfsd4: simplify stateid sequencing checks
      nfsd4: kill unnecessary check in preprocess_stateid_op
      svcrpc: move unused field from cache_deferred_req
      nfsd: clarify readdir/mountpoint-crossing code
      lockd: fix race in nlm_release()
      lockd: clean up __nsm_find()
      lockd: convert nsm_mutex to a spinlock
      nfsd: move most of fh_verify to separate function
      lockd: Fix stale nlmsvc_unlink_block comment
      nfsd: fix comment

James Lentini (1):
      Documentation: NFS/RDMA instructions for 2.6.25-rc1

Jeff Layton (10):
      SUNRPC: export svc_sock_update_bufs
      SUNRPC: have svc_recv() check kthread_should_stop()
      NLM: Convert lockd to use kthreads
      SUNRPC: allow svc_recv to break out of 500ms sleep when alloc_page fails
      NFS: convert nfs4 callback thread to kthread API
      SUNRPC: remove svc_create_thread()
      NFS: don't let nfs_callback_svc exit on unexpected svc_recv errors (try #2)
      NLM: don't let lockd exit on unexpected svc_recv errors (try #2)
      knfsd: get rid of imode variable in nfsd_setattr
      knfsd: clear both setuid and setgid whenever a chown is done

Kevin Coffman (4):
      Correct grammer/typos in dprintks
      Remove define for KRB5_CKSUM_LENGTH, which will become enctype-dependent
      gss_krb5: consistently use unsigned for seqnum
      sunrpc: make token header values less confusing

NeilBrown (1):
      knfsd: Remove NLM_HOST_MAX and associated logic.

Olga Kornievskaia (1):
      nfsd: use static memory for callback program and stats

Robert P. J. Day (1):
      NFSD: Strip __KERNEL__ testing from unexported header files.

Steven Whitehouse (1):
      Use a zero sized array for raw field in struct fid

Tom Tucker (1):
      SVCRDMA: Add check for XPT_CLOSE in svc_rdma_send

 Documentation/filesystems/nfs-rdma.txt   |  252 ++++++++++++++++++++++++++++++
 fs/Kconfig                               |  109 +++++++------
 fs/lockd/host.c                          |   73 +++++-----
 fs/lockd/svc.c                           |  150 ++++++++----------
 fs/lockd/svclock.c                       |    6 +-
 fs/lockd/svcshare.c                      |    3 +-
 fs/nfs/callback.c                        |   93 ++++++------
 fs/nfs/symlink.c                         |    1 -
 fs/nfsd/auth.c                           |    1 +
 fs/nfsd/export.c                         |    9 +-
 fs/nfsd/nfs4callback.c                   |   28 ++--
 fs/nfsd/nfs4idmap.c                      |    2 +-
 fs/nfsd/nfs4state.c                      |   71 +++++----
 fs/nfsd/nfs4xdr.c                        |   13 ++-
 fs/nfsd/nfsctl.c                         |   22 ++-
 fs/nfsd/nfsfh.c                          |  228 +++++++++++++++-------------
 fs/nfsd/nfssvc.c                         |    2 -
 fs/nfsd/vfs.c                            |   35 ++--
 include/linux/exportfs.h                 |    2 +-
 include/linux/nfs3.h                     |    2 +-
 include/linux/nfsd/Kbuild                |    4 +-
 include/linux/nfsd/cache.h               |    2 -
 include/linux/nfsd/nfsd.h                |   11 +-
 include/linux/sunrpc/cache.h             |    1 -
 include/linux/sunrpc/gss_krb5.h          |    6 +-
 include/linux/sunrpc/svc.h               |    1 -
 include/linux/sunrpc/svcauth.h           |    5 +-
 include/linux/sunrpc/svcsock.h           |    4 +-
 include/net/ipv6.h                       |    9 +
 net/sunrpc/auth_gss/gss_generic_token.c  |    4 +-
 net/sunrpc/auth_gss/gss_krb5_crypto.c    |    6 +-
 net/sunrpc/auth_gss/gss_krb5_seal.c      |    9 +-
 net/sunrpc/auth_gss/gss_krb5_seqnum.c    |    4 +-
 net/sunrpc/auth_gss/gss_krb5_unseal.c    |    2 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c      |    8 +-
 net/sunrpc/auth_gss/gss_spkm3_seal.c     |    4 +-
 net/sunrpc/auth_gss/svcauth_gss.c        |    9 +-
 net/sunrpc/cache.c                       |    1 -
 net/sunrpc/svc.c                         |   25 +--
 net/sunrpc/svc_xprt.c                    |   30 +++-
 net/sunrpc/svcauth_unix.c                |  118 ++++++++++-----
 net/sunrpc/svcsock.c                     |   29 ++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +
 43 files changed, 879 insertions(+), 517 deletions(-)
 create mode 100644 Documentation/filesystems/nfs-rdma.txt
