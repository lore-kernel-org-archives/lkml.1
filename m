Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614Ab0AGCWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab0AGCWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578Ab0AGCWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:22:49 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33487 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab0AGCWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C/pNgLAvFvl7l8ghNzkfVe+p7uZ1rVfaRoU5zdXGXZbUYvTz87RZUPhuUNvaSxz79X
         PFHrRBuT7sRlo6/HufAGN3CfESQT+vFkVaW/yIPyk53UKjZne8i4a9jTZYdajY+bTpNB
         pEc2oe8PsCzowv9CetqwKDno4KhAIC+0cV0H4=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] genksyms: close ref_file after use
Date: Thu,  7 Jan 2010 05:22:41 +0300
Message-Id: <1262830961-29911-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the last place when the file is read, so close it.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 scripts/genksyms/genksyms.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index af6b836..f99115e 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -758,8 +758,10 @@ int main(int argc, char **argv)
 		/* setlinebuf(debugfile); */
 	}
 
-	if (flag_reference)
+	if (flag_reference) {
 		read_reference(ref_file);
+		fclose(ref_file);
+	}
 
 	yyparse();
 
-- 
1.6.6

