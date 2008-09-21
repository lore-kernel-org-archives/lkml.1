Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYIUO0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYIUO0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYIUOZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:25:55 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:27373 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYIUOZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W1HHXReJaa4VmgLivd5yo2dz7f38kkPC8u9bIxR1fZqWrhWPbZ221hUm6fqUP8xiS4
         AF3DwpGY3NDPAjQZrY+gNQ8pNFeveuBvGIHlJFbngldeODGSoiOauSu221/Z2mM91uX1
         S80LbUHDtNV2JnkszYh1gho01t75f4W4keTXQ=
Date: Sun, 21 Sep 2008 23:25:40 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use platform_device_register_simple()
Message-ID: <20080921142538.GA8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup pcspeaker.c

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/pcspeaker.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

Index: 2.6-git/arch/x86/kernel/pcspeaker.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/pcspeaker.c
+++ 2.6-git/arch/x86/kernel/pcspeaker.c
@@ -1,20 +1,13 @@
 #include <linux/platform_device.h>
-#include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/init.h>
 
 static __init int add_pcspkr(void)
 {
 	struct platform_device *pd;
-	int ret;
 
-	pd = platform_device_alloc("pcspkr", -1);
-	if (!pd)
-		return -ENOMEM;
+	pd = platform_device_register_simple("pcspkr", -1, NULL, 0);
 
-	ret = platform_device_add(pd);
-	if (ret)
-		platform_device_put(pd);
-
-	return ret;
+	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
 }
 device_initcall(add_pcspkr);
