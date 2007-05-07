Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXEGFQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXEGFQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXEGFQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:16:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47874 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbXEGFQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:16:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] add support for reading stdin with gen_init_cpio
Date: Mon, 7 May 2007 01:17:17 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705070117.18435.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Treat an argument of "-" as meaning "read stdin for cpio files" so 
gen_init_cpio can be piped into.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 8365db6..7abc07f 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -498,7 +498,9 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
-	if (! (cpio_list = fopen(argv[1], "r"))) {
+	if (!strcmp(argv[1], "-"))
+		cpio_list = stdin;
+	else if (! (cpio_list = fopen(argv[1], "r"))) {
 		fprintf(stderr, "ERROR: unable to open '%s': %s\n\n",
 			argv[1], strerror(errno));
 		usage(argv[0]);
