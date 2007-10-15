Return-Path: <linux-kernel-owner+w=401wt.eu-S1764322AbXJOAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764322AbXJOAET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbXJOAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:04:11 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58249 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761167AbXJOAEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:04:09 -0400
Date: Sun, 14 Oct 2007 20:04:05 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       nfsv4@linux-nfs.org, Neil Brown <neilb@suse.de>
Subject: nfsd updates for 2.6.24
Message-ID: <20071015000405.GD31260@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You can pull the following nfs server changes from

  git://linux-nfs.org/~bfields/linux.git nfs-server-stable

Nothing earth-shaking this time; mainly small bugfixes and cleanups.

--b.

Andrew Morton (1):
      nfsd warning fix

Christoph Hellwig (1):
      nfsd: fix horrible indentation in nfsd_setattr

Dr. David Alan Gilbert (1):
      knfsd: Add source address to sunrpc svc errors

J. Bruce Fields (15):
      nfsd: tone down inaccurate dprintk
      nfsd: remove unused cache_for_each macro
      knfsd: delete code made redundant by map_new_errors
      knfsd: cleanup of nfsd4 cmp_* functions
      knfsd: demote some printk()s to dprintk()s
      knfsd: nfs4 name->id mapping not correctly parsing negative downcall
      knfsd: spawn kernel thread to probe callback channel
      knfsd: move nfsv4 slab creation/destruction to module init/exit
      knfsd: fix callback rpc cred
      knfsd: remove code duplication in nfsd4_setclientid()
      svcgss: move init code into separate function
      knfsd: let nfsd manage timing out its own leases
      knfsd: don't shutdown callbacks until nfsv4 client is freed
      knfsd: nfsv4 delegation recall should take reference on client
      knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME

Peter Staubach (1):
      knfsd: 64 bit ino support for NFS server

 fs/nfsd/nfs3xdr.c                 |   59 +++++------
 fs/nfsd/nfs4callback.c            |   89 +++++------------
 fs/nfsd/nfs4idmap.c               |    8 +-
 fs/nfsd/nfs4proc.c                |    4 +-
 fs/nfsd/nfs4state.c               |  200 +++++++++++++++++-------------------
 fs/nfsd/nfs4xdr.c                 |   22 ++--
 fs/nfsd/nfsctl.c                  |    7 +-
 fs/nfsd/nfssvc.c                  |    8 +-
 fs/nfsd/nfsxdr.c                  |    4 +
 fs/nfsd/vfs.c                     |   43 +++++---
 include/linux/nfsd/nfsd.h         |   18 ++--
 include/linux/nfsd/nfsfh.h        |   42 +-------
 include/linux/nfsd/xdr4.h         |    4 +-
 include/linux/sunrpc/cache.h      |   10 --
 net/sunrpc/auth_gss/svcauth_gss.c |  144 ++++++++++++++------------
 net/sunrpc/svc.c                  |   40 ++++++--
 16 files changed, 326 insertions(+), 376 deletions(-)
