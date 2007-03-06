Return-Path: <linux-kernel-owner+w=401wt.eu-S1030729AbXCFXxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030729AbXCFXxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030735AbXCFXxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:53:06 -0500
Received: from mail.queued.net ([207.210.101.209]:1950 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030729AbXCFXxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:53:05 -0500
Message-ID: <45EDFEDB.3000507@debian.org>
Date: Tue, 06 Mar 2007 18:52:59 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: don't use ZONE_DMA unless CONFIG_ZONE_DMA is set in setup.c
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------020309060909000708020808"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020309060909000708020808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If CONFIG_ZONE_DMA is ever undefined, ZONE_DMA will also not be defined,
and setup.c won't compile.  This wraps it with an #ifdef.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------020309060909000708020808
Content-Type: text/x-patch;
 name="zones.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="zones.patch"

diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 0b476e1..b69626e 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -371,8 +371,10 @@ void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] =
 		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;

--------------020309060909000708020808--
