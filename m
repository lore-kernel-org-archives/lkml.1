Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZAGVuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZAGVuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZAGVtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:49:23 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39887 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbZAGVtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:49:21 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Crutcher Dunnavant <crutcher+kernel@datastacks.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 3/3] sysrq: add commentary on why we use the console loglevel over using KERN_EMERG
Date: Wed,  7 Jan 2009 21:49:18 +0000
Message-Id: <1231364958-26253-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231364958-26253-1-git-send-email-apw@canonical.com>
References: <1231364958-26253-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an explanitory comment as to why we modify the kernel console
loglevel rather than simply moving sysrq messages to KERN_EMERG level.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/char/sysrq.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index d41b9f6..33a9351 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -473,6 +473,12 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	/*
+	 * Raise the apparent loglevel to maximum so that the sysrq header
+	 * is shown to provide the user with positive feedback.  We do not
+	 * simply emit this at KERN_EMERG as that would change message
+	 * routing in the consumers of /proc/kmsg.
+	 */
 	orig_log_level = console_loglevel;
 	console_loglevel = 7;
 	printk(KERN_INFO "SysRq : ");
-- 
1.6.0.4.911.gc990

