Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbYASPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbYASPrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759384AbYASPrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:47:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38281 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759156AbYASPrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:47:09 -0500
Date: Sat, 19 Jan 2008 15:44:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mingo@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 reboot: Remove inb_p usage
Message-ID: <20080119154453.1afddbfb@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are driving a motherboard port so use a 2uS explicit delay at this
point.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c linux-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c
--- linux.vanilla-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c	2008-01-19 14:47:55.000000000 +0000
+++ linux-2.6.24-rc8-mm1/arch/x86/kernel/reboot.c	2008-01-19 14:53:58.000000000 +0000
@@ -319,9 +319,11 @@
 {
 	int i;
 
-	for (i = 0; i < 0x10000; i++)
-		if ((inb_p(0x64) & 0x02) == 0)
+	for (i = 0; i < 0x10000; i++) {
+		if ((inb(0x64) & 0x02) == 0)
 			break;
+		udelay(2);
+	}
 }
 
 void machine_emergency_restart(void)
