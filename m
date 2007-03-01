Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbXCAHQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbXCAHQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXCAHQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:16:08 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:45673 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742AbXCAHQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:16:06 -0500
Subject: [PATCH 1/5] Remove hardcoding of hard_smp_processor_id on UP
	systems
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 01 Mar 2007 16:16:31 +0900
Message-Id: <1172733391.1498.266.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the advent of kdump, the assumption that the boot CPU when booting
an UP kernel is always the CPU with a hardware ID of 0 (usually referred
to as BSP on some architectures) is not valid anymore.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc2/include/linux/smp.h linux-2.6.21-rc2-hwcpuid/include/linux/smp.h
--- linux-2.6.21-rc2/include/linux/smp.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc2-hwcpuid/include/linux/smp.h	2007-03-07 12:02:13.000000000 +0900
@@ -83,7 +83,6 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-#define hard_smp_processor_id()			0
 static inline int up_smp_call_function(void)
 {
 	return 0;


