Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZFHVIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZFHVIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZFHVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:08:45 -0400
Received: from mx2.netapp.com ([216.240.18.37]:6098 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZFHVIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:08:44 -0400
X-IronPort-AV: E=Sophos;i="4.41,326,1241420400"; 
   d="scan'208";a="187723541"
Subject: [GIT PULL] Please pull a bugfix for NFSv4...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rich Ercolani <rercola@acm.jhu.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 08 Jun 2009 17:08:44 -0400
Message-Id: <1244495324.5040.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 08 Jun 2009 21:08:45.0414 (UTC) FILETIME=[4F341860:01C9E87D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "bugfixes" branch of the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git bugfixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

commit fa4156cbc5844f7649ae586207660cb2e98ba970
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon Jun 8 16:02:58 2009 -0400

    NFSv4: Fix the 'nolock' option regression
    
    NFSv4 should just ignore the 'nolock' option. It is an NFSv2/v3 thing...
    This fixes the Oops in http://bugzilla.kernel.org/show_bug.cgi?id=13330
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index d2d6778..36c94dc 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2238,6 +2238,11 @@ static void nfs4_fill_super(struct super_block *sb)
 	nfs_initialise_sb(sb);
 }
 
+static void nfs4_validate_mount_flags(struct nfs_parsed_mount_data *args)
+{
+	args->flags &= ~(NFS_MOUNT_NONLM|NFS_MOUNT_NOACL|NFS_MOUNT_VER3);
+}
+
 /*
  * Validate NFSv4 mount options
  */
@@ -2334,6 +2339,8 @@ static int nfs4_validate_mount_data(void *options,
 
 		nfs_validate_transport_protocol(args);
 
+		nfs4_validate_mount_flags(args);
+
 		if (args->auth_flavor_len > 1)
 			goto out_inval_auth;
 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
