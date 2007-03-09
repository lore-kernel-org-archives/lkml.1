Return-Path: <linux-kernel-owner+w=401wt.eu-S2993063AbXCIH2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993063AbXCIH2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993060AbXCIH2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:28:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:38428 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993062AbXCIH2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:28:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=AtgQd3YjfXTwHs5AkhHFLc6Gbbr5FtmoRdsVFHEXXLn1lA4L5esxPOKyeJflqcSan00/slh6nLPtvUkNTBwaNNHstCk9PioChIuOysTf7A8iDIsg1oRbuFFHPz42XjImlQiN9/JxAUo0TP8nkGlM0xGETv9MQhJ7Jr4ZdKu3R1w=
Date: Thu, 8 Mar 2007 23:27:47 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/jffs2/scan.c: Fix error-path leak
Message-Id: <20070308232747.1605e81c.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Fix error-path leak in function jffs2_scan_medium(), in file fs/jffs2/scan.c

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index e241346..cd9ed6e 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -130,6 +130,8 @@ #endif
 	if (jffs2_sum_active()) {
 		s = kmalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
 		if (!s) {
+			free(flashbuf);
+			flashbuf = NULL;
 			JFFS2_WARNING("Can't allocate memory for summary\n");
 			return -ENOMEM;
 		}
