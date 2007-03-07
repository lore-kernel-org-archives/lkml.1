Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXCGPcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXCGPcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXCGPcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:32:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43543 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751889AbXCGPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:32:10 -0500
Date: Wed, 7 Mar 2007 16:36:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH] dilnetpc: Fix warning
Message-ID: <20070307163601.3662aec1@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The type of a resource could be 32 or 64bit depending upon platform or
option so cast it explicitly.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/drivers/mtd/maps/dilnetpc.c linux-2.6.21-rc2-mm2/drivers/mtd/maps/dilnetpc.c
--- linux.vanilla-2.6.21-rc2-mm2/drivers/mtd/maps/dilnetpc.c	2007-03-06 23:06:09.000000000 +0000
+++ linux-2.6.21-rc2-mm2/drivers/mtd/maps/dilnetpc.c	2007-03-06 19:09:22.000000000 +0000
@@ -402,8 +402,8 @@
 			++higlvl_partition_info[i].name;
 	}
 
-	printk(KERN_NOTICE "DIL/Net %s flash: 0x%lx at 0x%lx\n",
-		is_dnp ? "DNPC" : "ADNP", dnpc_map.size, dnpc_map.phys);
+	printk(KERN_NOTICE "DIL/Net %s flash: 0x%lx at 0x%llx\n",
+		is_dnp ? "DNPC" : "ADNP", dnpc_map.size, (unsigned long long)dnpc_map.phys);
 
 	dnpc_map.virt = ioremap_nocache(dnpc_map.phys, dnpc_map.size);
 
