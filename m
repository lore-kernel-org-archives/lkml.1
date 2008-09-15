Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYIOVKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYIOVKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYIOVGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:49 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64417 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbYIOVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:28 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 06/14] KConfig: Add KConfig entries for Labeled NFS
Date: Mon, 15 Sep 2008 16:41:10 -0400
Message-Id: <1221511278-28051-7-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two entries into the fs/KConfig file. The first entry
NFS_V4_SECURITY_LABEL enables security label support for the NFSv4 client while
the second entry NFSD_V4_SECURITY_LABEL enables security labeling support on
the server side.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/Kconfig |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index abccb5d..47ffb42 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1633,6 +1633,7 @@ config NFS_V4
 
 	  If unsure, say N.
 
+
 config ROOT_NFS
 	bool "Root file system on NFS"
 	depends on NFS_FS=y && IP_PNP
@@ -1644,6 +1645,15 @@ config ROOT_NFS
 
 	  Most people say N here.
 
+config NFS_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 client"
+	depends on NFS_V4 && SECURITY
+	help
+	  Say Y here if you want label attribute support for NFS version 4.
+
+
+	  If unsure, say N.
+
 config NFSD
 	tristate "NFS server support"
 	depends on INET
@@ -1725,6 +1735,13 @@ config NFSD_V4
 
 	  If unsure, say N.
 
+config NFSD_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 server"
+	depends on NFSD_V4 && SECURITY
+	help
+	  If you would like to include support for label file attributes
+	  over NFSv4, say Y here.
+
 config LOCKD
 	tristate
 
-- 
1.5.5.1

