Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZIYXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZIYXCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZIYXCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:02:45 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:31973 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZIYXCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:02:44 -0400
Message-ID: <4ABD4C28.9070202@oracle.com>
Date: Fri, 25 Sep 2009 16:03:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com
Subject: [PATCH -next] drbd: trace depends on TRACING
References: <20090925133830.1ba29584.sfr@canb.auug.org.au>
In-Reply-To: <20090925133830.1ba29584.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ABD4BE9.001A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

DRBD_TRACE should depend on TRACING.
It's also possible that TRACEPOINTS should depend on TRACING.

arch/x86/built-in.o: In function `default_idle':
(.text+0x145a1): undefined reference to `__tracepoint_power_start'
arch/x86/built-in.o: In function `default_idle':
(.text+0x145d4): undefined reference to `__tracepoint_power_start'
arch/x86/built-in.o: In function `mwait_idle_with_hints':
(.text+0x1583d): undefined reference to `__tracepoint_power_start'
arch/x86/built-in.o: In function `mwait_idle_with_hints':
(.text+0x15870): undefined reference to `__tracepoint_power_start'
arch/x86/built-in.o: In function `mwait_idle':
process.c:(.text+0x15b92): undefined reference to `__tracepoint_power_start'
arch/x86/built-in.o:process.c:(.text+0x15bbe): more undefined references to `__tracepoint_power_start' follow
arch/x86/built-in.o: In function `poll_idle':
process.c:(.text+0x160bd): undefined reference to `__tracepoint_power_end'
process.c:(.text+0x160e9): undefined reference to `__tracepoint_power_end'
drivers/built-in.o: In function `cpuidle_idle_call':
cpuidle.c:(.text+0x517f16): undefined reference to `__tracepoint_power_end'
cpuidle.c:(.text+0x517f49): undefined reference to `__tracepoint_power_end'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/drbd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090925.orig/drivers/block/drbd/Kconfig
+++ linux-next-20090925/drivers/block/drbd/Kconfig
@@ -40,7 +40,7 @@ config BLK_DEV_DRBD
 
 config DRBD_TRACE
 	tristate "DRBD tracing"
-	depends on BLK_DEV_DRBD
+	depends on BLK_DEV_DRBD && TRACING
 	select TRACEPOINTS
 	default n
 	help
