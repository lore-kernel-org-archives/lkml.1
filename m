Return-Path: <linux-kernel-owner+w=401wt.eu-S1161282AbXBZWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161282AbXBZWXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161286AbXBZWXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:23:36 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45105 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161282AbXBZWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:23:36 -0500
Date: Mon, 26 Feb 2007 23:23:36 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] LGUEST must depend on NET
Message-ID: <20070226222336.GC29575@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_LGUEST=y, CONFIG_NET=n results in the following compile error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `lguestnet_close':
lguest_net.c:(.text+0x3b8de): undefined reference to `kfree_skb'
drivers/built-in.o: In function `fill_slot':
lguest_net.c:(.text+0x3ba08): undefined reference to `__alloc_skb'
drivers/built-in.o: In function `lguestnet_open':
lguest_net.c:(.text+0x3bada): undefined reference to `kfree_skb'
drivers/built-in.o: In function `lguestnet_start_xmit':
lguest_net.c:(.text+0x3bc03): undefined reference to `kfree_skb'
drivers/built-in.o: In function `lguestnet_rcv':
lguest_net.c:(.text+0x3bc61): undefined reference to `kfree_skb'
lguest_net.c:(.text+0x3bc6c): undefined reference to `skb_put'
lguest_net.c:(.text+0x3bc76): undefined reference to `eth_type_trans'
lguest_net.c:(.text+0x3bc94): undefined reference to `netif_rx'
drivers/built-in.o: In function `lguestnet_probe':
lguest_net.c:(.text+0x3bcdb): undefined reference to `alloc_etherdev'
lguest_net.c:(.text+0x3bcea): undefined reference to `ether_setup'
lguest_net.c:(.text+0x3bdc1): undefined reference to `register_netdev'
lguest_net.c:(.text+0x3be10): undefined reference to `unregister_netdev'
lguest_net.c:(.text+0x3be17): undefined reference to `free_netdev'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/arch/i386/Kconfig.old	2007-02-26 22:14:48.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/Kconfig	2007-02-26 22:15:51.000000000 +0100
@@ -258,7 +258,7 @@
 
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE
+	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
 	select LGUEST_GUEST
 	select HVC_DRIVER
 	---help---

