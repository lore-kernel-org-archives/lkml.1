Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZCPVgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZCPVgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbZCPVg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:36:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:26328 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419AbZCPVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:36:26 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v3 1/3] memory_accessor: new interface for reading/writing persistent memory
Date: Mon, 16 Mar 2009 14:36:17 -0700
Message-Id: <1237239379-24186-2-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
References: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface by which other kernel code can read/write
persistent memory such as I2C or SPI EEPROMs, or devices which provide
NVRAM.  Use cases include storage of board-specific configuration data
like Ethernet addresses and sensor calibrations.

Original idea, review and improvement suggestions by David Brownell.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 include/linux/memory.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index 3fdc108..42767d1 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -99,4 +99,15 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+/*
+ * 'struct memory_accessor' is a generic interface to provide
+ * in-kernel access to persistent memory such as i2c or SPI EEPROMs
+ */
+struct memory_accessor {
+	ssize_t (*read)(struct memory_accessor *, char *buf, off_t offset,
+			size_t count);
+	ssize_t (*write)(struct memory_accessor *, const char *buf,
+			 off_t offset, size_t count);
+};
+
 #endif /* _LINUX_MEMORY_H_ */
-- 
1.6.1.3

