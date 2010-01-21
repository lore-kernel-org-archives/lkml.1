Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535Ab0AUGdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0AUGdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707Ab0AUGdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:33:35 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38846 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab0AUG3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:29:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 20 Jan 2010 22:28:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 25/36] x86: print out for RAM buffer
In-reply-to: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264055303-15123-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could check that early in bootlog

Acked-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 arch/x86/kernel/e820.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c5c52da..62235e7 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1127,6 +1127,9 @@ void __init e820_reserve_resources_late(void)
 			end = MAX_RESOURCE_SIZE;
 		if (start >= end)
 			continue;
+		printk(KERN_DEBUG "reserve RAM buffer: %016Lx - %016Lx ",
+			       (unsigned long long) start,
+			       (unsigned long long) end);
 		reserve_region_with_split(&iomem_resource, start, end,
 					  "RAM buffer");
 	}
-- 
1.6.4.2

