Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbYJRQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbYJRQLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYJRQLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:11:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:10492 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYJRQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=prwgYzeHA1U42pv0kIOrzydmxBhVpkH8QaQYFV2TNRUa2KJXDKTTCX0FUjxjDd0xix
         /fkmUZ5GxZRRv3BkPuGWusGhFfL730ljrdfm0/iW0AzUxN0OZE0y5lY5kZTX5dO0eBAg
         lY8goHvUcMmIneJwdMCnrSagHy9SFEy/0VE8o=
Message-ID: <48FA0AB6.3060505@gmail.com>
Date: Sat, 18 Oct 2008 18:11:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc: correct section of apc_no_idle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest mainline gives this section mismatch on sparc:

The function __devinit apc_probe() references
a variable __initdata apc_no_idle.
If apc_no_idle is only used by apc_probe then
annotate apc_no_idle with a matching annotation.

Since the commit 7e7e2f035663c5ceb029bfb9d91e75099b0a5625,
apc_probe() is on __devinit so we have to correct apc_no_idle
which is referenced by this function.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 4dd1ba7..9c11582 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -31,7 +31,7 @@
 #define APC_DEVNAME "apc"
 
 static u8 __iomem *regs;
-static int apc_no_idle __initdata = 0;
+static int apc_no_idle __devinitdata = 0;
 
 #define apc_readb(offs)		(sbus_readb(regs+offs))
 #define apc_writeb(val, offs) 	(sbus_writeb(val, regs+offs))
