Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYFLWNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYFLWNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYFLWMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:12:53 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44220 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759199AbYFLWMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:12:51 -0400
Date: Fri, 13 Jun 2008 01:11:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] mn10300: export kernel_thread
Message-ID: <20080612221143.GR17231@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes thefollowing build error:

<--  snip  -->

...
  MODPOST 1310 modules
ERROR: "kernel_thread" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "kernel_thread" [net/ipv4/ipvs/ip_vs.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/hidp/hidp.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/cmtp/cmtp.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/bnep/bnep.ko] undefined!
ERROR: "kernel_thread" [fs/nfs/nfs.ko] undefined!
ERROR: "kernel_thread" [fs/lockd/lockd.ko] undefined!
ERROR: "kernel_thread" [fs/jffs2/jffs2.ko] undefined!
...
WARNING: modpost: Found 2 section mismatch(es).

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/mn10300/kernel/mn10300_ksyms.c |    3 +++
 1 file changed, 3 insertions(+)

f6120ef1dbb0831e753b6f241bbca4600aa94c10 diff --git a/arch/mn10300/kernel/mn10300_ksyms.c b/arch/mn10300/kernel/mn10300_ksyms.c
index 6d19628..aba584a 100644
--- a/arch/mn10300/kernel/mn10300_ksyms.c
+++ b/arch/mn10300/kernel/mn10300_ksyms.c
@@ -10,6 +10,7 @@
  */
 #include <linux/module.h>
 #include <asm/uaccess.h>
+#include <asm/processor.h>
 
 
 EXPORT_SYMBOL(change_bit);
@@ -35,3 +36,5 @@ EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__lshrdi3);
 EXPORT_SYMBOL(__negdi2);
+
+EXPORT_SYMBOL(kernel_thread);

