Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZBITTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZBITTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZBITS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:18:58 -0500
Received: from mx2.netapp.com ([216.240.18.37]:40383 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZBITS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:18:57 -0500
X-IronPort-AV: E=Sophos;i="4.37,406,1231142400"; 
   d="scan'208";a="124987090"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [RFC PATCH 0/2] Add VFS support for looking up paths on remote
 servers using a temporary mount namespace
To: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Mon, 09 Feb 2009 13:45:34 -0500
Message-ID: <20090209184534.23040.82605.stgit@heimdal.trondhjem.org>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
X-OriginalArrivalTime: 09 Feb 2009 19:18:51.0024 (UTC) FILETIME=[3D7BC900:01C98AEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches attempt to improve NFSv4's ability to look up
the mount path on a remote server.

The first patch adds VFS support for walking the remote path, using a
temporary mount namespace to represent the server's namespace, so that
symlinks and referrals can be followed across remote filesystem and
server boundaries.
The second patch then uses this VFS helper in the NFSv4 mount code.

A later set of patches will clean out the legacy nfs4_path_walk, however
I'm hoping for some commentary from the VFS folks on whether or not this
approach is acceptable before I continue.

Cheers
  Trond

---

Trond Myklebust (2):
      NFSv4: Use vfs_path_lookup() instead of nfs4_path_walk()
      VFS: Add a VFS helper function vfs_remote_path_lookup()


 fs/namei.c                    |   75 ++++++++++++++++++++-
 fs/namespace.c                |   56 +++++++++++++--
 fs/nfs/super.c                |  149 +++++++++++++++++++++++++++++++++++------
 include/linux/mnt_namespace.h |    2 +
 include/linux/namei.h         |    2 +
 include/linux/nsproxy.h       |    1 
 kernel/nsproxy.c              |   11 +++
 7 files changed, 267 insertions(+), 29 deletions(-)

-- 
Signature
