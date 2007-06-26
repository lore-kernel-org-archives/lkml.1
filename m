Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXFZXwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXFZXwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbXFZXwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:52:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbXFZXwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:52:12 -0400
Date: Tue, 26 Jun 2007 16:52:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-Id: <20070626165202.bfe8e6df.akpm@linux-foundation.org>
In-Reply-To: <20070626230756.519733902@suse.de>
References: <20070626230756.519733902@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 16:07:56 -0700
jjohansen@suse.de wrote:

> This post contains patches to include the AppArmor application security
> framework, with request for inclusion into -mm for wider testing.

Patches 24 and 31 didn't come through.

Rolled-up diffstat (excluding 24&31):

 fs/attr.c                            |    7 
 fs/dcache.c                          |  181 ++-
 fs/ecryptfs/inode.c                  |   41 
 fs/exec.c                            |    3 
 fs/fat/file.c                        |    2 
 fs/hpfs/namei.c                      |    2 
 fs/namei.c                           |  115 +-
 fs/nfsd/nfs4recover.c                |    7 
 fs/nfsd/nfs4xdr.c                    |    2 
 fs/nfsd/vfs.c                        |   89 +
 fs/ntfs/file.c                       |    2 
 fs/open.c                            |   50 
 fs/reiserfs/file.c                   |    2 
 fs/reiserfs/xattr.c                  |    8 
 fs/splice.c                          |    4 
 fs/stat.c                            |    2 
 fs/sysfs/file.c                      |    2 
 fs/utimes.c                          |   11 
 fs/xattr.c                           |   75 -
 fs/xfs/linux-2.6/xfs_lrw.c           |    2 
 include/linux/audit.h                |   12 
 include/linux/fs.h                   |   27 
 include/linux/nfsd/nfsd.h            |    3 
 include/linux/security.h             |  182 ++-
 include/linux/sysctl.h               |    2 
 include/linux/xattr.h                |   11 
 ipc/mqueue.c                         |    2 
 kernel/audit.c                       |    6 
 kernel/sysctl.c                      |   27 
 mm/filemap.c                         |   12 
 mm/filemap_xip.c                     |    2 
 mm/shmem.c                           |    2 
 mm/tiny-shmem.c                      |    2 
 net/unix/af_unix.c                   |    2 
 security/Kconfig                     |    1 
 security/Makefile                    |    1 
 security/apparmor/Kconfig            |   10 
 security/apparmor/Makefile           |   13 
 security/apparmor/apparmor.h         |  265 +++++
 security/apparmor/apparmorfs.c       |  252 +++++
 security/apparmor/inline.h           |  211 ++++
 security/apparmor/list.c             |   94 +
 security/apparmor/locking.txt        |   68 +
 security/apparmor/lsm.c              |  817 ++++++++++++++++
 security/apparmor/main.c             | 1255 +++++++++++++++++++++++++
 security/apparmor/match.c            |  248 ++++
 security/apparmor/match.h            |   83 +
 security/apparmor/module_interface.c |  589 +++++++++++
 security/apparmor/procattr.c         |  155 +++
 security/commoncap.c                 |    7 
 security/dummy.c                     |   43 
 security/selinux/hooks.c             |   94 -
 52 files changed, 4701 insertions(+), 404 deletions(-)

which seems OK.


so...  where do we stand with this?  Fundamental, irreconcilable
differences over the use of pathname-based security?

Are there any other sticking points?


