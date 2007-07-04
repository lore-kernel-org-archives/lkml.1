Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbXGDVOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbXGDVOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXGDVOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:14:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41067 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372AbXGDVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:14:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 4 Jul 2007 23:13:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: raw1394: fix a 32/64-bits compat fix
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.b9bdb16d8ffd3fd1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was told that only i386 aligns 64 bit integers at 4 bytes boundaries
while all other architectures (32 bit architectures with 64 bit
siblings) align it on 8 bytes boundaries.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/raw1394.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -434,7 +434,11 @@ struct compat_raw1394_req {
 
 	__u64 sendb;
 	__u64 recvb;
-} __attribute__((packed));
+}
+#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
+__attribute__((packed))
+#endif
+;
 
 static const char __user *raw1394_compat_write(const char __user *buf)
 {

-- 
Stefan Richter
-=====-=-=== -=== --=--
http://arcgraph.de/sr/

