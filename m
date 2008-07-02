Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYGBAtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYGBAtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 20:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbYGBAtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 20:49:08 -0400
Received: from mx2.netapp.com ([216.240.18.37]:22639 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbYGBAtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 20:49:06 -0400
X-IronPort-AV: E=Sophos;i="4.27,734,1204531200"; 
   d="scan'208";a="4146533"
Subject: Re: inux-next: Tree for July 1
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <200807012236.19400.rjw@sisk.pl>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
	 <200807012236.19400.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 01 Jul 2008 20:49:03 -0400
Message-Id: <1214959743.10317.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 02 Jul 2008 00:49:04.0095 (UTC) FILETIME=[6CE03EF0:01C8DBDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 22:36 +0200, Rafael J. Wysocki wrote:
> I can't mount NFS shares with this kernel.  I get something of this sort in
> dmesg and it seems to be 100% reproducible:
> 
> [  314.058858] RPC: Registered udp transport module.
> [  314.058863] RPC: Registered tcp transport module.
> [  314.490970] RPC: transport (0) not supported
> [  319.246987] __ratelimit: 23 messages suppressed

Does this patch fix the problem for you?
-----------------------------------------------------------------------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
NFS: Fix the mount protocol defaults for binary mounts

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index e09b1c2..85fbb98 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1575,6 +1575,7 @@ static int nfs_validate_mount_data(void *options,
 
 		if (!(data->flags & NFS_MOUNT_TCP))
 			args->nfs_server.protocol = XPRT_TRANSPORT_UDP;
+		nfs_set_transport_defaults(args);
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrdup(data->hostname, GFP_KERNEL);
 		args->namlen		= data->namlen;


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
