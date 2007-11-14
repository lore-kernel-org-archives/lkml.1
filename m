Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXKNQMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXKNQMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbXKNQMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:12:01 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:39920 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXKNQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:12:00 -0500
Message-ID: <473B1E4D.40800@schaufler-ca.com>
Date: Wed, 14 Nov 2007 08:11:57 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] For -mm only - inode_getsecurity rework
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

This represents the rework required for changes to inode_getsecurity.
It is relative to smack24rc2v11, which is the version added to -mm,
but subsequently removed because of the change to inode_getsecurity

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack_lsm.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -uprN -X linux-2.6.24-rc2-base/Documentation/dontdiff linux-2.6.24-rc2-smack/security/smack/smack_lsm.c linux-2.6.24-rc2-mm1-smack/security/smack/smack_lsm.c
--- linux-2.6.24-rc2-smack/security/smack/smack_lsm.c	2007-11-07 21:35:41.000000000 -0800
+++ linux-2.6.24-rc2-mm1-smack/security/smack/smack_lsm.c	2007-11-12 22:49:16.000000000 -0800
@@ -673,8 +673,8 @@ static int smack_inode_removexattr(struc
  * Returns the size of the attribute or an error code
  */
 static int smack_inode_getsecurity(const struct inode *inode,
-				   const char *name, void *buffer,
-				   size_t size, int err)
+				   const char *name, void **buffer,
+				   bool alloc)
 {
 	struct socket_smack *ssp;
 	struct socket *sock;
@@ -687,9 +687,7 @@ static int smack_inode_getsecurity(const
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
 		isp = smk_of_inode(inode);
 		ilen = strlen(isp) + 1;
-		if (ilen > size)
-			return -EINVAL;
-		strncpy(buffer, isp, ilen);
+		*buffer = isp;
 		return ilen;
 	}
 
@@ -714,10 +712,8 @@ static int smack_inode_getsecurity(const
 		return -EOPNOTSUPP;
 
 	ilen = strlen(isp) + 1;
-	if (ilen > size)
-		rc = -EINVAL;
 	if (rc == 0) {
-		strncpy(buffer, isp, ilen);
+		*buffer = isp;
 		rc = ilen;
 	}
 




