Return-Path: <linux-kernel-owner+w=401wt.eu-S1946481AbXBIOaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946481AbXBIOaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946482AbXBIOaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:30:55 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57969 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946481AbXBIOaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:30:55 -0500
Date: Fri, 9 Feb 2007 15:30:29 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Don't include linux/mtd/map.h from linux/mtd/physmap.h
Message-ID: <20070209153029.1ffe2420@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the inclusion of linux/mtd/map.h with a forward-declaration
of struct map_info. This allows linux/mtd/physmap.h to be included by
e.g. board code even if the MTD subsystem is disabled.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 include/linux/mtd/physmap.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/physmap.h b/include/linux/mtd/physmap.h
index 86831e3..0dc07d5 100644
--- a/include/linux/mtd/physmap.h
+++ b/include/linux/mtd/physmap.h
@@ -18,9 +18,10 @@
 #define __LINUX_MTD_PHYSMAP__
 
 #include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
 
+struct map_info;
+
 struct physmap_flash_data {
 	unsigned int		width;
 	void			(*set_vpp)(struct map_info *, int);
-- 
1.4.4.3

