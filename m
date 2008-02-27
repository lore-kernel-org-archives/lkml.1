Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYB0XIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYB0XIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYB0XIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:08:23 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:48304 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYB0XIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:08:22 -0500
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 18:08:22 EST
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 04/11] KConfig: Add KConfig entries for SELinux labeled NFS
Date: Wed, 27 Feb 2008 17:11:27 -0500
Message-Id: <1204150294-4678-5-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two entries into the fs/KConfig file. The first entry
NFS_V4_SECURITY_LABEL enables security label support for the NFSv4 client while
the second entry NFSD_V4_SECURITY_LABEL enables security labeling support on
the server side. These entries are currently marked as EXPERIMENTAL to indicate
that at the moment they are only suitable for testing purposes and that the
functionality they provide may change before it is removed from experimental
status.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/Kconfig |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..d762375 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1637,6 +1637,14 @@ config NFS_V4
 
 	  If unsure, say N.
 
+config NFS_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 client"
+	depends on NFS_V4 && SECURITY && EXPERIMENTAL
+	help
+	  Say Y here if you want label attribute support for NFS version 4.
+
+	  If unsure, say N.
+
 config NFS_DIRECTIO
 	bool "Allow direct I/O on NFS files"
 	depends on NFS_FS
@@ -1728,6 +1736,15 @@ config NFSD_V4
 	  should only be used if you are interested in helping to test NFSv4.
 	  If unsure, say N.
 
+config NFSD_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 server"
+	depends on NFSD_V4 && SECURITY && EXPERIMENTAL
+	help
+	  If you would like to include support for label file attributes
+	  over NFSv4, say Y here.
+
+	  If unsure, say N.
+
 config NFSD_TCP
 	bool "Provide NFS server over TCP support"
 	depends on NFSD
-- 
1.5.3.8

