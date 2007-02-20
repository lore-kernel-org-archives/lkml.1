Return-Path: <linux-kernel-owner+w=401wt.eu-S1750957AbXBTAIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbXBTAIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965605AbXBTAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:09 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36151 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965584AbXBTAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:07 -0500
Date: Tue, 20 Feb 2007 01:08:06 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.21 patch] fix the SYSCTL=n compilation
Message-ID: <20070220000806.GJ13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with CONFIG_SYSCTL=n:

<--  snip  -->

...
  CC      kernel/sysctl.o
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/kernel/sysctl.c:1411: error: conflicting types for 'register_sysctl_table'
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/include/linux/sysctl.h:1042: error: previous declaration of 'register_sysctl_table' was here
make[2]: *** [kernel/sysctl.o] Error 1

<--  snip  -->


Caused by commit 0b4d414714f0d2f922d39424b0c5c82ad900a381.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/kernel/sysctl.c.old	2007-02-19 17:52:28.000000000 +0100
+++ linux-2.6.20-mm2/kernel/sysctl.c	2007-02-19 17:53:22.000000000 +0100
@@ -1406,8 +1406,7 @@
 }
 
 #else /* !CONFIG_SYSCTL */
-struct ctl_table_header * register_sysctl_table(ctl_table * table,
-						int insert_at_head)
+struct ctl_table_header *register_sysctl_table(ctl_table * table)
 {
 	return NULL;
 }

