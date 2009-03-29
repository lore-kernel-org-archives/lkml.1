Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZC2T4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZC2T4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZC2T4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:56:11 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:35769 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZC2T4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:56:10 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/1] Add missing includes into include/linux/irq.h
Date: Sun, 29 Mar 2009 22:55:51 +0300
Message-Id: <1238356551-22685-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file include/linux/irq.h does not include the necessary
headers for all entities it makes use of. This has produced the
following build error on MIPS:

  CC      arch/mips/mti-malta/malta-int.o
In file included from arch/mips/mti-malta/malta-int.c:25:
include/linux/irq.h: In function 'init_alloc_desc_masks':
include/linux/irq.h:444: error: implicit declaration of function
'cpu_to_node'
include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in
this function)
include/linux/irq.h:446: error: (Each undeclared identifier is reported
only once
include/linux/irq.h:446: error: for each function it appears in.)
make[1]: *** [arch/mips/mti-malta/malta-int.o] Error 1
make: *** [arch/mips/mti-malta] Error 2

This patch adds missing includes and fixes the build error above.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 include/linux/irq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 873e4ac..03bfc87 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -20,6 +20,8 @@
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/errno.h>
+#include <linux/topology.h>
+#include <linux/gfp.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
-- 
1.5.6.3

