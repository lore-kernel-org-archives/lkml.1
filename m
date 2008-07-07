Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYGGWB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYGGWB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbYGGWAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:00:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:12844 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbYGGWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=tklJq6mqRHvqBUJXkcAtaPxTR0/X98MgsunrwUBKyUC/NYF6MxZ45KPtKgQeY0+SxN
         jVJ2VuiKmoDddKBQKk2FytlyeqBPFW5HeKaQMIcz9RpIYg4zoHXwBzft2lbzBD9pTP3R
         c8tXXaHY13hAin1knkpcwqmK3F7owfX5E2Fq4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/10] ide-generic: fix ide_default_io_base() for m32r
Date: Mon, 7 Jul 2008 23:52:59 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807072352.59495.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ide_default_io_base() to match ide_default_irq().

Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-m32r/ide.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/include/asm-m32r/ide.h
===================================================================
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -52,12 +52,20 @@ static __inline__ int ide_default_irq(un
 static __inline__ unsigned long ide_default_io_base(int index)
 {
 	switch (index) {
+#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
+	|| defined(CONFIG_PLAT_OPSPUT)
+		case 0:	return 0x1f0;
+#elif defined(CONFIG_PLAT_MAPPI3)
+		case 0:	return 0x1f0;
+		case 1:	return 0x170;
+#else
 		case 0:	return 0x1f0;
 		case 1:	return 0x170;
 		case 2: return 0x1e8;
 		case 3: return 0x168;
 		case 4: return 0x1e0;
 		case 5: return 0x160;
+#endif
 		default:
 			return 0;
 	}
