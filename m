Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbZJFVBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbZJFVBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZJFVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:01:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1903 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbZJFVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:01:43 -0400
Subject: [PATCH] kernel.h: Remove initialization of bool in printk_once
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Oct 2009 14:01:06 -0700
Message-Id: <1254862866.2134.78.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't initialize __print_once
Invert the test to reduce initialized data.

defconfig before:	$size vmlinux
   text	   data	    bss	    dec	    hex	filename
6976022	 679572	1359668	9015262	 898fde	vmlinux

defconfig after:	$size vmlinux
   text	   data	    bss	    dec	    hex	filename
6976006	 679508	1359700	9015214	 898fae	vmlinux

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d3cd23f..344873d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -252,10 +252,10 @@ extern int printk_delay_msec;
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
 #define printk_once(x...) ({			\
-	static bool __print_once = true;	\
+	static bool __print_once;		\
 						\
-	if (__print_once) {			\
-		__print_once = false;		\
+	if (!__print_once) {			\
+		__print_once = true;		\
 		printk(x);			\
 	}					\
 })


