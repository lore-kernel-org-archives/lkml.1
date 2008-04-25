Return-Path: <linux-kernel-owner+w=401wt.eu-S1765856AbYDYSEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765856AbYDYSEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764710AbYDYR5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:32 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40412 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764695AbYDYR5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:21 -0400
Date: Fri, 25 Apr 2008 13:57:13 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: more nfsd changes for 2.6.26
Message-ID: <20080425175713.GA1057@fieldses.org>
References: <20080423213337.GG8302@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423213337.GG8302@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more nfsd-related changes are available in the git repository at:

	git://linux-nfs.org/~bfields/linux.git for-linus

Mainly this adds a couple new interfaces from Wendy Cheng which allow
userland to tell the nfs server to drop locks held on a given filesystem
(or held by clients accessing the server via a given server ip address),
helpful in high-availability setups when taking down a server whose job
is being taken over by another.

(This could have probably gone with the first pull request, but the
patches were still getting a little work--a small bugfix, and some
fiddling with function names and such.)

The rest are miscellaneous minor bugfixes and cleanup.

--b.

David M. Richter (4):
      leases: fix a return-value mixup
      leases: when unlocking, skip locking-related steps
      leases: move lock allocation earlier in generic_setlease()
      leases: remove unneeded variable from fcntl_setlease().

J. Bruce Fields (2):
      locks: don't call ->copy_lock methods on return of conflicting locks
      nfsd: don't allow setting ctime over v4

James Lentini (1):
      Update to NFS/RDMA documentation

Wendy Cheng (2):
      lockd: unlock lockd locks associated with a given server ip
      lockd: unlock lockd locks held for a certain filesystem

 Documentation/filesystems/nfs-rdma.txt |   14 ++++--
 fs/lockd/svclock.c                     |    2 +-
 fs/lockd/svcsubs.c                     |   69 ++++++++++++++++++++++++++++----
 fs/locks.c                             |   32 ++++++++-------
 fs/nfsd/nfs4state.c                    |    3 -
 fs/nfsd/nfs4xdr.c                      |   14 ------
 fs/nfsd/nfsctl.c                       |   65 ++++++++++++++++++++++++++++++
 include/linux/fs.h                     |    1 +
 include/linux/lockd/lockd.h            |    8 +++-
 include/linux/nfsd/nfsd.h              |    2 +-
 10 files changed, 162 insertions(+), 48 deletions(-)

