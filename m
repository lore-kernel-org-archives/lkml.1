Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZKVWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZKVWAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 17:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZKVWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 17:00:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:4234 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZKVWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 17:00:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=myRnzjFbJXxFCihWvDl/efarVr5I/dR+NLAJXieKA6fRpv+4+UtJov7IRXdrU1qCwI
         xzBIuAbYOrHSEYaauZertQVa898FH/VAFoAb7Ukg42nWUv00IgHjFyf494F1MHXj0w4p
         T0ezXjdc17WSkXw0F8uBO+yPxSnVR63+HqFEs=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, otus-devel@venema.h4ckr.net, Luiz.Rodrigues@atheros.com,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH v3] staging/otus: fix some sparse waring.
Date: Sun, 22 Nov 2009 17:00:00 -0500
Message-Id: <1258927200-3703-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*apdbg.c: use NULL pointer instead of 0 interger. Also make two functions private.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/staging/otus/apdbg.c |   53 +++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index 0eb93f1..b59028e 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -90,8 +90,27 @@ struct zdap_ioctl {
 
 #endif
 
-char hex(char);
-unsigned char asctohex(char *str);
+static char hex(char v)
+{
+	if (isdigit(v))
+		return v - '0';
+	else if (isxdigit(v))
+		return tolower(v) - 'a' + 10;
+	else
+		return 0;
+}
+
+static unsigned char asctohex(char *str)
+{
+	unsigned char value;
+
+	value = hex(*str) & 0x0f;
+	value = value << 4;
+	str++;
+	value |= hex(*str) & 0x0f;
+
+	return value;
+}
 
 char *prgname;
 
@@ -109,10 +128,10 @@ int set_ioctl(int sock, struct ifreq *req)
 
 int read_reg(int sock, struct ifreq *req)
 {
-	struct zdap_ioctl *zdreq = 0;
+	struct zdap_ioctl *zdreq = NULL;
 
 	if (!set_ioctl(sock, req))
-			return -1;
+		return -1;
 
 	/*
 	 * zdreq = (struct zdap_ioctl *)req->ifr_data;
@@ -125,7 +144,7 @@ int read_reg(int sock, struct ifreq *req)
 
 int read_mem(int sock, struct ifreq *req)
 {
-	struct zdap_ioctl *zdreq = 0;
+	struct zdap_ioctl *zdreq = NULL;
 	int i;
 
 	if (!set_ioctl(sock, req))
@@ -368,7 +387,7 @@ int main(int argc, char **argv)
 
 		zdreq.addr = addr;
 		zdreq.cmd = ZM_IOCTL_SET_PIBSS_MODE;
-	} else 	{
+	} else {
 		fprintf(stderr, "error action\n");
 		exit(1);
 	}
@@ -380,25 +399,3 @@ fail:
 	exit(0);
 }
 
-unsigned char asctohex(char *str)
-{
-	unsigned char value;
-
-	value = hex(*str) & 0x0f;
-	value = value << 4;
-	str++;
-	value |= hex(*str) & 0x0f;
-
-	return value;
-}
-
-char hex(char v)
-{
-	if (isdigit(v))
-		return v - '0';
-	else if (isxdigit(v))
-		return tolower(v) - 'a' + 10;
-	else
-		return 0;
-}
-
-- 
1.6.5.2.180.gc5b3e

