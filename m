Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbXHBSVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbXHBSVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbXHBSU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:20:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:5025 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbXHBSU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=C7u/vM+UJYyD0YVefsUeHGypfhmPFvw462xJH5Yg6dgMJrVLBntSWPIMl0SW3n7NvEARlJ5Px6v0CHEOSYm5UNSDpXxLkilAAHPhCj0ha6SgJYI7O7V4+Km9+I0xHKKZeqtuZZCnl4BoLrqh7xr9SU7aHL3grKEilyL3jJngIso=
Message-ID: <46B2207C.9060406@googlemail.com>
Date: Thu, 02 Aug 2007 20:20:44 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] Fix section mismatch warnings for drivers/mmc/host
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch warnings

...

WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

---

 drivers/mmc/host/wbsd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index e0c9808..9bf2a87 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1266,7 +1266,7 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
 	return 0;
 }
 
-static void __devexit wbsd_free_mmc(struct device *dev)
+static void wbsd_free_mmc(struct device *dev)
 {
 	struct mmc_host *mmc;
 	struct wbsd_host *host;
@@ -1358,7 +1358,7 @@ static int __devinit wbsd_request_region(struct wbsd_host *host, int base)
 	return 0;
 }
 
-static void __devexit wbsd_release_regions(struct wbsd_host *host)
+static void wbsd_release_regions(struct wbsd_host *host)
 {
 	if (host->base)
 		release_region(host->base, 8);
@@ -1434,7 +1434,7 @@ err:
 		"Falling back on FIFO.\n", dma);
 }
 
-static void __devexit wbsd_release_dma(struct wbsd_host *host)
+static void wbsd_release_dma(struct wbsd_host *host)
 {
 	if (host->dma_addr) {
 		dma_unmap_single(mmc_dev(host->mmc), host->dma_addr,
@@ -1484,7 +1484,7 @@ static int __devinit wbsd_request_irq(struct wbsd_host *host, int irq)
 	return 0;
 }
 
-static void __devexit wbsd_release_irq(struct wbsd_host *host)
+static void  wbsd_release_irq(struct wbsd_host *host)
 {
 	if (!host->irq)
 		return;
@@ -1535,7 +1535,7 @@ static int __devinit wbsd_request_resources(struct wbsd_host *host,
  * Release all resources for the host.
  */
 
-static void __devexit wbsd_release_resources(struct wbsd_host *host)
+static void wbsd_release_resources(struct wbsd_host *host)
 {
 	wbsd_release_dma(host);
 	wbsd_release_irq(host);
