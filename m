Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYH0N10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYH0N10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYH0N1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:27:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:57135 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYH0N1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:27:13 -0400
From: Thomas Renninger <trenn@suse.de>
To: ak@linux.intel.com
Cc: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       linux-acpi@vger.kernel.org, ckornacker@suse.de,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/3] Introduce FW_BUG and FW_INFO to consistenly tell users about BIOS bugs
Date: Wed, 27 Aug 2008 15:27:09 +0200
Message-Id: <1219843631-26015-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <200808210919.07642.bjorn.helgaas@hp.com>
References: <200808210919.07642.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is to add this to printk after the severity:
printk(KERN_ERR FW_BUG "This is not our fault\n");

If a Firmware issue should be hidden, because it is
work-arounded, but you still want to see something popping up e.g.
for info only:
printk(KERN_INFO FW_INFO "This is done stupid, we can handle it,
but it should better be avoided in future\n");

or on the Linuxfirmwarekit to tell vendors that they did something
stupid or wrong without bothering the user:
printk(KERN_INFO FW_BUG "This is done stupid, we can handle it,
but it should better be avoided in future\n");

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 include/linux/kernel.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..68ebfc2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -190,6 +190,9 @@ extern int kernel_text_address(unsigned long addr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
+#define FW_BUG		"[FW Bug]: "
+#define FW_INFO		"[FW Info]: "
+
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-- 
1.5.4.5

