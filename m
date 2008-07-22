Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYGVA3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYGVA3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYGVA3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbYGVA3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tYCHpPHCRsk2Hw9al7uX2Oa8B4qHNDeS4yHP8QBCjLMV6FhkVMJAdPzJVvJBv48n4Y
         DFjeq/dQJ6nHMjexT2VZleCW9ME8T42AwjXhbWaKnwS4+MJLtmccvLXBuPnFQR0Xr8WI
         kHc5+lNeGSd+yCVBSB5wpd3RBaKh78s4QhjzU=
Message-ID: <488529DC.2030504@gmail.com>
Date: Mon, 21 Jul 2008 20:29:16 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] auditsc: test below 0 on unsigned ino
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ino is unsigned so the test didn't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c10e7aa..dc8e0a4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -286,7 +286,7 @@ static int audit_match_filetype(struct audit_context *ctx, int which)
 	mode_t mode = which & S_IFMT;
 	if (index >= ctx->name_count)
 		return 0;
-	if (ctx->names[index].ino == -1)
+	if (ctx->names[index].ino == -1ul)
 		return 0;
 	if ((ctx->names[index].mode ^ mode) & S_IFMT)
 		return 0;
