Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0CIUSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:18:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:59542 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751494Ab0CIUSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:18:45 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19ZDuJ4qxxZRqpSWEu0VkdK7B/doXxFCZeEuMWbib
	Ak6pXVfK7NuUrb
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] serial/sh_sci: Fix build failure for non-sh architectures
Date: Tue, 9 Mar 2010 21:18:25 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.27-05415-g69a8594; KDE/4.3.5; x86_64; ; )
Cc: Magnus Damm <damm@igel.co.jp>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003092118.26274.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure for various arm based defconfigs
[1][2][3] and maybe other architectures/configs.

The build failure was introduced by the sh specific patch [4]
"serial: sh-sci: Add DMA support"
by Guennadi Liakhovetski

Patch against linux-next of 20100309

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2248992/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/2248996/
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2248998/
[4] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=73a19e4c0301908ce6346715fd08a74308451f5a

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 include/linux/serial_sci.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/serial_sci.h b/include/linux/serial_sci.h
index 1b177d2..193d4bf 100644
--- a/include/linux/serial_sci.h
+++ b/include/linux/serial_sci.h
@@ -2,7 +2,9 @@
 #define __LINUX_SERIAL_SCI_H
 
 #include <linux/serial_core.h>
+#ifdef CONFIG_SERIAL_SH_SCI_DMA
 #include <asm/dmaengine.h>
+#endif
 
 /*
  * Generic header for SuperH SCI(F) (used by sh/sh64/h8300 and related parts)
@@ -30,8 +32,10 @@ struct plat_sci_port {
 	upf_t		flags;			/* UPF_* flags */
 	char		*clk;			/* clock string */
 	struct device	*dma_dev;
+#ifdef CONFIG_SERIAL_SH_SCI_DMA
 	enum sh_dmae_slave_chan_id dma_slave_tx;
 	enum sh_dmae_slave_chan_id dma_slave_rx;
+#endif
 };
 
 #endif /* __LINUX_SERIAL_SCI_H */
-- 
1.6.4.4

