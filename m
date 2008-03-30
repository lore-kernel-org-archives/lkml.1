Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYC3WkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYC3WkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYC3WkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:40:10 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53753 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYC3WkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:09 -0400
Date: Mon, 31 Mar 2008 01:39:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Igor Mammedov <niallain@gmail.com>, Steve French <sfrench@us.ibm.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] cifs: make connect_to_dfs_path() static
Message-ID: <20080330223956.GA28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

connect_to_dfs_path() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/cifs/cifsproto.h |    3 ---
 fs/cifs/connect.c   |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

87f02b93ed23ec4229a006d5866745473cb4c15e diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7e5e0e7..c9dd2ca 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -154,9 +154,6 @@ extern int CIFSGetDFSRefer(const int xid, struct cifsSesInfo *ses,
 			unsigned int *number_of_UNC_in_array,
 			const struct nls_table *nls_codepage, int remap);
 
-extern int connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
-			const char *old_path,
-			const struct nls_table *nls_codepage, int remap);
 extern int get_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
 			const char *old_path,
 			const struct nls_table *nls_codepage,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8dbfa97..61b2b0a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1405,7 +1405,7 @@ find_unc(__be32 new_target_ip_addr, char *uncName, char *userName)
 	return NULL;
 }
 
-int
+static int
 connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
 		    const char *old_path, const struct nls_table *nls_codepage,
 		    int remap)

