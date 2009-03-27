Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZC0KhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZC0KhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZC0KhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:37:10 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:59946 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZC0KhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:37:09 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/1] Add missing include into include/linux/netdevice.h
Date: Fri, 27 Mar 2009 12:36:53 +0200
Message-Id: <1238150213-30416-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline function skb_gro_mac_header defined in include/linux/netdevice.h
makes use of page_address(). Depending on configuration options, the latter
is either defined as a macro or is declared as a function in another header
file, namely include/linux/mm.h. However, include/linux/netdevice.h does not
include include/linux/mm.h.

On MIPS, this has produced the following build error:

  CC      kernel/sysctl_check.o
In file included from include/linux/icmpv6.h:173,
                 from include/linux/ipv6.h:208,
                 from include/net/ip_vs.h:26,
                 from kernel/sysctl_check.c:6:
include/linux/netdevice.h: In function 'skb_gro_mac_header':
include/linux/netdevice.h:1132: error: implicit declaration of function
'page_address'
include/linux/netdevice.h:1133: warning: pointer/integer type mismatch
in conditional expression
make[1]: *** [kernel/sysctl_check.o] Error 1
make: *** [kernel] Error 2

The patch adds the missing include and fixes the build error.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 include/linux/netdevice.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index be3ebd7..1b55952 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -32,6 +32,7 @@
 #ifdef __KERNEL__
 #include <linux/timer.h>
 #include <linux/delay.h>
+#include <linux/mm.h>
 #include <asm/atomic.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
-- 
1.5.6.3

