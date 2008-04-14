Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbYDNOWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbYDNOWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760804AbYDNOUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:20:45 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41352 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761236AbYDNOUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:20:43 -0400
Date: Mon, 14 Apr 2008 17:19:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mn10300: export kernel_thread
Message-ID: <20080414141938.GK6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1256 modules
ERROR: "kernel_thread" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "kernel_thread" [net/ipv4/ipvs/ip_vs.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/hidp/hidp.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/cmtp/cmtp.ko] undefined!
ERROR: "kernel_thread" [net/bluetooth/bnep/bnep.ko] undefined!
ERROR: "kernel_thread" [fs/nfs/nfs.ko] undefined!
ERROR: "kernel_thread" [fs/lockd/lockd.ko] undefined!
ERROR: "kernel_thread" [fs/jffs2/jffs2.ko] undefined!
ERROR: "kernel_thread" [drivers/usb/atm/usbatm.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ca4c4f445e4b7cfbedc815cfc08ab2c70581c774 diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 3b0d579..194574e 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -154,6 +154,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0,
 		       NULL, NULL);
 }
+EXPORT_SYMBOL_GPL(kernel_thread);
 
 /*
  * free current thread data structures etc..

