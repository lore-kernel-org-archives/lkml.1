Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZFAGZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZFAGZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZFAGZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:25:01 -0400
Received: from mailgw3.cms.com ([202.75.200.223]:6569 "EHLO cms.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbZFAGZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:25:00 -0400
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2009 02:24:58 EDT
X-Originating-IP: 172.19.23.105
X-Auth-User: vibi_sreenivasan@cms.com
X-Filename: C:\PROGRA~1\MailScan\in\SMT1736600136104.TMP
Subject: [PATCH]:Return proper error value on failure of dentry_open
From: vibi sreenivasan <vibi_sreenivasan@cms.com>
Reply-To: vibi_sreenivasan@cms.com
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Kylene Hall <kylene@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: CMS
Date: Mon, 01 Jun 2009 11:41:48 +0530
Message-Id: <1243836708.2163.3.camel@system>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8)
Content-Transfer-Encoding: 7bit
X-Trained: 2
X-MS-ContentScanSkipped: Mail Not From Internet
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    dentry_open can return error value on error.
    Check that value before calling fput & return proper error value

Signed-off-by: vibi sreenivasan <vibi_sreenivasan@cms.com>
---
 security/integrity/ima/ima_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index f4e7266..c58158b 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -201,10 +201,10 @@ int ima_path_check(struct path *path, int mask)
 	}
 out:
 	mutex_unlock(&iint->mutex);
-	if (file)
+	if (IS_ERR(file))
 		fput(file);
 	kref_put(&iint->refcount, iint_free);
-	return 0;
+	return rc;
 }
 
 static int process_measurement(struct file *file, const unsigned char *filename,
-- 
1.6.0



