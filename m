Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbYBHR5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbYBHR5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbYBHR47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:56:59 -0500
Received: from flpi102.sbcis.sbc.com ([207.115.20.71]:15592 "EHLO
	flpi102.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYBHR46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:56:58 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 12:56:58 EST
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 10/11] NFSD: Remove redundant "select" clauses in fs/Kconfig
To: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org
Date: Fri, 08 Feb 2008 12:52:37 -0500
Message-ID: <20080208175237.16261.51118.stgit@manray.1015granger.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell, selecting the CRYPTO and CRYPTO_MD5 entries under
CONFIG_NFSD is redundant, since CONFIG_NFSD_V4 already selects
RPCSEC_GSS_KRB5, which selects these entries.

Testing with "make menuconfig" shows that the entries under CRYPTO still
properly reflect "Y" or "M" based on the setting of CONFIG_NFSD after this
change is applied.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---

 fs/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 21362e9..f799964 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1658,8 +1658,6 @@ config NFSD
 	select SUNRPC
 	select EXPORTFS
 	select NFS_ACL_SUPPORT if NFSD_V2_ACL
-	select CRYPTO_MD5 if NFSD_V4
-	select CRYPTO if NFSD_V4
 	help
 	  Choose Y here if you want to allow other computers to access
 	  files residing on this system using Sun's Network File System

