Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbXD2DW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbXD2DW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXD2DWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:22:33 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:34270 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbXD2DWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:31 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="36822432:sNHT23407979"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/7] blackfin arch: fix bug refuse to boot if rootfs image is not attached when MTD_UCLINUX is selected
Date: Sun, 29 Apr 2007 11:23:08 +0800
Message-Id: <11778169952824-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11778169933996-git-send-email-bryan.wu@analog.com>
References: <11778169933996-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 76e1f10..6a2190f 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -293,6 +293,11 @@ void __init setup_arch(char **cmdline_p)
 
 	memory_end -= mtd_size;
 
+	if (mtd_size == 0) {
+		console_init();
+		panic("Don't boot kernel without rootfs attached.\n");
+	}
+
 	/* Relocate MTD image to the top of memory after the uncached memory area */
 	dma_memcpy((char *)memory_end, __bss_stop, mtd_size);
 
-- 
1.5.1.2
