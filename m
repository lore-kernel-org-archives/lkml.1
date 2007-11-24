Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXKXW4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXKXW4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXKXWz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:55:56 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58746 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXKXWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:55:55 -0500
Date: Sat, 24 Nov 2007 14:58:09 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not set boot cpu in cpu_online_map at
 x86_64_start_kernel
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200711241458.09399.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: not set boot cpu in cpu_online_map at x86_64_start_kernel

in init/main.c boot_cpu_init() does that later

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 6b34693..82b9f03 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -67,8 +67,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	pda_init(0);
 	copy_bootdata(__va(real_mode_data));
-#ifdef CONFIG_SMP
-	cpu_set(0, cpu_online_map);
-#endif
+
 	start_kernel();
 }
