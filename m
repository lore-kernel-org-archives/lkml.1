Return-Path: <linux-kernel-owner+w=401wt.eu-S934731AbYBHSEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731AbYBHSEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934283AbYBHR7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:59:19 -0500
Received: from flpi102.sbcis.sbc.com ([207.115.20.71]:18710 "EHLO
	flpi102.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbYBHR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:59:18 -0500
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 06/11] NFSD: Remove NFSv4 dependency on NFSv3
To: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org
Date: Fri, 08 Feb 2008 12:52:08 -0500
Message-ID: <20080208175208.16261.74626.stgit@manray.1015granger.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up: Because NFSD_V4 "depends on" NFSD_V3, it appears as a child of
the NFSD_V3 menu entry, and is not visible if NFSD_V3 is unselected.

Replace the dependency on NFSD_V3 with a "select NFSD_V3".  This makes
NFSD_V4 look and work just like NFS_V3, while ensuring that NFSD_V3 is
enabled if NFSD_V4 is.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---

 fs/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 9ad62a9..4c16789 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1723,7 +1723,8 @@ config NFSD_V3_ACL
 
 config NFSD_V4
 	bool "NFS server support for NFS version 4 (EXPERIMENTAL)"
-	depends on NFSD && NFSD_V3 && EXPERIMENTAL
+	depends on NFSD && EXPERIMENTAL
+	select NFSD_V3
 	select RPCSEC_GSS_KRB5
 	help
 	  This option enables support in your system's NFS server for

