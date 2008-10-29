Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYJ2PQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYJ2PQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYJ2PQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:16:04 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:39970 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752732AbYJ2PQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:16:01 -0400
X-YMail-OSG: xVd2shgVM1mOihtTKKbPgGEoF3vhBFBlE8NMTnf4CzzY1yHq4wtdATnx9nXOd6ccb2CjWAPvAuKPmv1_fZKeR.sb9QjGQw.rnRDMHmf3rDYyaWuSEJjJDNnYiz06Xq3fFeVSd913RBiJP1NPaLOMOHH1kVMblk_gZXWPJdipKdS2fsjl4lXLmNSg0YM-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49087E26.2080905@schaufler-ca.com>
Date: Wed, 29 Oct 2008 08:15:50 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
CC: Rob MacKinnon <c4blem0nkey@gmail.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, rob.mackinnon@gmail.com,
       hpa@zytor.com, hugh@veritas.com
Subject: [PATCH] smack inode_listsecurity fix
References: <4902DD98.4090302@gmail.com> <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil> <200810272153.56301.agruen@suse.de> <49062EC0.4040809@gmail.com> <4906A871.6010501@schaufler-ca.com>
In-Reply-To: <4906A871.6010501@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

This patch fixes the problem known by "tmpfs support of xattrs?"
which is in fact the result of a bad implementation of the
inode_listsecurity LSM hook in Smack. Thanks to Stephen Smalley,
who identified the problem and all but coded the fix before I'd
even heard about it.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack_lsm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/security/smack/smack_lsm.c linux-smack/security/smack/smack_lsm.c
--- linux-2.6/security/smack/smack_lsm.c	2008-10-26 17:37:08.000000000 -0700
+++ linux-smack/security/smack/smack_lsm.c	2008-10-26 19:11:23.000000000 -0700
@@ -763,13 +763,11 @@ static int smack_inode_getsecurity(const
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
 {
-	int len = strlen(XATTR_NAME_SMACK);
+	int len = sizeof(XATTR_NAME_SMACK);
 
-	if (buffer != NULL && len <= buffer_size) {
+	if (buffer != NULL && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SMACK, len);
-		return len;
-	}
-	return -EINVAL;
+	return len;
 }
 
 /**



