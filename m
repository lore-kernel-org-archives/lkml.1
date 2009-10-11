Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZJKAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZJKAyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 20:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZJKAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 20:54:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46150 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbZJKAym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 20:54:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 Oct 2009 02:54:01 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] NFS: suppress a build warning
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.c698a40fc77b434b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sockaddr_storage * can safely be used as struct sockaddr *.
Suppress an "incompatible pointer type" warning.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6dabf6f..f54afbf 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1848,8 +1848,8 @@ nfs_compare_remount_data(struct nfs_server *nfss,
 	    data->timeo != (10U * nfss->client->cl_timeout->to_initval / HZ) ||
 	    data->nfs_server.port != nfss->port ||
 	    data->nfs_server.addrlen != nfss->nfs_client->cl_addrlen ||
-	    !rpc_cmp_addr(&data->nfs_server.address,
-		    &nfss->nfs_client->cl_addr))
+	    !rpc_cmp_addr((struct sockaddr *)&data->nfs_server.address,
+		    	  (struct sockaddr *)&nfss->nfs_client->cl_addr))
 		return -EINVAL;
 
 	return 0;
-- 
Stefan Richter
-=====-==--= =-=- -=-==
http://arcgraph.de/sr/

