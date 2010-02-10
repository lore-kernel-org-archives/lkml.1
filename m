Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0BJJ1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:27:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60042 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0BJJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:50 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/35] x86: print out for RAM buffer
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could check that early in bootlog

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 arch/x86/kernel/e820.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a966b75..f406efe 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1429,6 +1429,8 @@ void __init e820_reserve_resources_late(void)
 			end = MAX_RESOURCE_SIZE;
 		if (start >= end)
 			continue;
+		printk(KERN_DEBUG "reserve RAM buffer: %016llx - %016llx ",
+			       start, end);
 		reserve_region_with_split(&iomem_resource, start, end,
 					  "RAM buffer");
 	}
-- 
1.6.4.2

