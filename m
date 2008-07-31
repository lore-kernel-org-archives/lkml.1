Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYGaJ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYGaJ0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYGaJ0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:26:02 -0400
Received: from neon.ftbfs.org ([83.168.236.214]:37695 "EHLO neon.ftbfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYGaJ0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:26:01 -0400
X-Greylist: delayed 3017 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 05:26:00 EDT
Date: Thu, 31 Jul 2008 01:35:25 -0700
From: Matt Kraai <kraai@ftbfs.org>
To: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, stable@kernel.org
Subject: [PATCH] netfilter: Move linux/in.h and linux/in6.h inclusions
	outside of #ifdef __KERNEL__
Message-ID: <20080731083525.GC7164@ftbfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score-Int: -41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Kraai <kraai@ftbfs.org>

netfilter.h can't be used in userspace without including linux/in.h
and linux/in6.h first. netfilter.h includes its own linux/in.h and
linux/in6.h include statements, these are stripped by make
headers-install because they are inside #ifdef __KERNEL__ however.
Move them out to fix this.

Signed-off-by: Matt Kraai <kraai@ftbfs.org>

---

The original report of this bug is at
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=487103.

This patch applies to the latest linux-2.6 tree.

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0c5eb7e..6060e56 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -7,13 +7,13 @@
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/if.h>
-#include <linux/in.h>
-#include <linux/in6.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <net/net_namespace.h>
 #endif
 #include <linux/types.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 #include <linux/compiler.h>
 
 /* Responses from hook functions. */
