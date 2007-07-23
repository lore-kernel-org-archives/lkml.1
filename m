Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXGWNK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXGWNK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXGWNKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:10:16 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36705 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbXGWNKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:10:15 -0400
Date: Mon, 23 Jul 2007 15:10:09 +0200 (MEST)
Message-Id: <200707231310.l6NDA9Dn004031@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.23-rc1 broke APM
Cc: hpa@zytor.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On this machine (Gigabyte mobo with i815EP chipset and a PIII),
APM worked fine up to 2.6.22. With 2.6.23-rc1 however the APM
driver fails to locate the APM bios:

--- dmesg-2.6.22	2007-07-23 14:07:46.000000000 +0200
+++ dmesg-2.6.23-rc1	2007-07-23 14:48:24.000000000 +0200
@@ -102,7 +105,7 @@
 Unpacking initramfs... done
 Freeing initrd memory: 976k freed
 Machine check exception polling timer started.
-apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
+apm: BIOS not found.
 io scheduler noop registered
 io scheduler anticipatory registered (default)
 io scheduler deadline registered

The only change in 2.6.23-rc1 to arch/i386/kernel/apm.c is a
trivial nofreeze flag removal, so I suspect the boot code changes,
perhaps the new arch/i386/boot/apm.c:query_apm_bios().

/Mikael
