Return-Path: <linux-kernel-owner+w=401wt.eu-S1764042AbYD2N2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764042AbYD2N2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbYD2N2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:28:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55992 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753085AbYD2N2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:28:36 -0400
Date: Tue, 29 Apr 2008 14:20:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] toshiba: Use ioremap_cached
Message-ID: <20080429142023.093bfba6@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch of ioremap to default to uncached doesn't break this driver
but it does needlessly slow it down as BIOS space is cachable and this
driver is quite happy scanning cached ROM space.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/toshiba.c linux-2.6.25-mm1/drivers/char/toshiba.c
--- linux.vanilla-2.6.25-mm1/drivers/char/toshiba.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/toshiba.c	2008-04-28 11:51:54.000000000 +0100
@@ -426,7 +426,7 @@
 	int i,major,minor,day,year,month,flag;
 	unsigned char signature[7] = { 0x54,0x4f,0x53,0x48,0x49,0x42,0x41 };
 	SMMRegisters regs;
-	void __iomem *bios = ioremap(0xf0000, 0x10000);
+	void __iomem *bios = ioremap_cache(0xf0000, 0x10000);
 
 	if (!bios)
 		return -ENOMEM;
