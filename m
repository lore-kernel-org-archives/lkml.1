Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbXKJPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbXKJPRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXKJPRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:17:11 -0500
Received: from mx01.hansenet.de ([213.191.73.25]:40668 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751564AbXKJPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:17:10 -0500
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2007 10:17:10 EST
From: Thomas Koeller <thomas@koeller.dyndns.org>
Date: Sat, 10 Nov 2007 15:55:15 +0100
Subject: [PATCH] Include header required for INT_MAX
X-Length: 770
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <20071110145627.C6FE347A7C@mail.koeller.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cdrom.h uses INT_MAX, so it must include kernel.h or
limits.h (userspace) for a definition.

Signed-off-by: Thomas Koeller <thomas@koeller.dyndns.org>

diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index c6d3e22..bd8064a 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -12,6 +12,11 @@
 #define	_LINUX_CDROM_H
 
 #include <asm/byteorder.h>
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+#else
+#include <limits.h>
+#endif
 
 /*******************************************************
  * As of Linux 2.1.x, all Linux CD-ROM application programs will use this 
-- 
1.5.3.4

