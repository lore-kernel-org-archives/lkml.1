Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZFVTWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZFVTWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZFVTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:21:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:6263 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZFVTU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:20:59 -0400
X-IronPort-AV: E=Sophos;i="4.42,270,1243839600"; 
   d="scan'208";a="194527933"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 0/5] NFS private namespace patchset
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 15:09:13 -0400
Message-ID: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 22 Jun 2009 19:20:59.0803 (UTC) FILETIME=[932EA6B0:01C9F36E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is a resend of a set of patches that were
originally targetted for inclusion in 2.6.30-rc1. They build upon
Al Viro's "Cache root in nameidata" patches, and add the ability to
create a private mount namespace that is not visible to user
processes.
As stated before, the goal is to allow reuse of vfs_path_lookup() in
order to allow the nfs client to walk down NFSv4 mount paths, and locate
the directory that needs to be mounted.

There have been no further comments on these patches since I mailed the
last revision, so I'm hoping that Al and Christoph will ack them and
that Linus will apply...

Cheers
  Trond

---

Trond Myklebust (5):
      NFS: Correct the NFS mount path when following a referral
      NFS: Fix nfs_path() to always return a '/' at the beginning of the path
      NFSv4: Replace nfs4_path_walk() with VFS path lookup in a private namespace
      VFS: Add VFS helper functions for setting up private namespaces
      VFS: Uninline the function put_mnt_ns()


 fs/namespace.c                |   53 +++++++++--
 fs/nfs/namespace.c            |    5 +
 fs/nfs/super.c                |  202 +++++++++++++++++++++++++++++++++++++----
 include/linux/mnt_namespace.h |   10 --
 4 files changed, 231 insertions(+), 39 deletions(-)

-- 
Signature
