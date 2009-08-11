Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZHKP2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZHKP2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZHKP2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:28:09 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:40684 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZHKP2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:28:09 -0400
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
To: linux-kernel@vger.kernel.org
Subject: [PATCH]  CIFS: memory leakage at ./fs/cifs/cifsencrypt.c
Date: Tue, 11 Aug 2009 19:28:09 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111928.10196.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 in function calc_ntlmv2_hash memory is not released.
1. If in the line 333 we successfully allocate memory and assign it to 
pctxt variable:
        pctxt = kmalloc(sizeof(struct HMACMD5Context), GFP_KERNEL);
then we go to line 376 and exit wihout releasing memory pointed to by pctxt
variable.

Add a memory  releasing for pctxt variable before exit from function 
calc_ntlmv2_hash.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/a/fs/cifs/cifsencrypt.c b/b/fs/cifs/cifsencrypt.c
index 7c98095..7efe174 100644
--- a/a/fs/cifs/cifsencrypt.c
+++ b/b/fs/cifs/cifsencrypt.c
@@ -373,6 +373,7 @@ calc_exit_2:
           compare with the NTLM example */
        hmac_md5_final(ses->server->ntlmv2_hash, pctxt);

+       kfree(pctxt);
        return rc;
 }

