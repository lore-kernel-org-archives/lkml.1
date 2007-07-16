Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbXGPLl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbXGPLl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbXGPLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:41:51 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36493 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbXGPLlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:41:51 -0400
Date: Mon, 16 Jul 2007 14:41:48 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
cc: ericvh@gmail.com
Subject: 9P compile fix
Message-ID: <Pine.SOC.4.64.0707161432480.1471@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With 9P but no 9P debug options, this error occurs:
  CC [M]  fs/9p/v9fs.o
fs/9p/v9fs.c: In function 'v9fs_parse_options':
fs/9p/v9fs.c:134: error: 'p9_debug_level' undeclared (first use in this function)

The following patch moves the definition of p9_debug_level out of #ifdef 
and seems to fix the compilation.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 88884d3..8fc3796 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -27,6 +27,8 @@
 #ifndef NET_9P_H
 #define NET_9P_H
 
+extern unsigned int p9_debug_level;
+
 #ifdef CONFIG_NET_9P_DEBUG
 
 #define P9_DEBUG_ERROR		(1<<0)
@@ -38,8 +40,6 @@
 #define P9_DEBUG_SLABS	      	(1<<7)
 #define P9_DEBUG_FCALL		(1<<8)
 
-extern unsigned int p9_debug_level;
-
 #define P9_DPRINTK(level, format, arg...) \
 do {  \
 	if ((p9_debug_level & level) == level) \

-- 
Meelis Roos (mroos@linux.ee)
