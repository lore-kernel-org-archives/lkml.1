Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0BICm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:42:57 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:57548 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0BICmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:42:55 -0500
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org
Subject: [PATCH] printk: Avoid warning when CONFIG_PRINTK is disabled
Date: Tue,  9 Feb 2010 00:42:47 -0200
Message-Id: <1265683367-25845-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/printk.c:72: warning: ‘saved_console_loglevel’ defined but not used
---
 kernel/printk.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 1751c45..ed6487d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -69,8 +69,6 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
-static int saved_console_loglevel = -1;
-
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -145,6 +143,7 @@ static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
+static int saved_console_loglevel = -1;
 
 #ifdef CONFIG_KEXEC
 /*
-- 
1.6.4.4

