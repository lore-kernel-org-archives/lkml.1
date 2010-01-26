Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697Ab0AZR6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0AZR6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474Ab0AZR6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:58:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41823 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab0AZR6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:58:01 -0500
Subject: [PATCH] kmemleak: Do not enable KMEMCHECK_PARTIAL_OK if DEBUG_KMEMLEAK
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christian Casteyde <casteyde.christian@free.fr>
Date: Tue, 26 Jan 2010 17:57:19 +0000
Message-ID: <20100126175719.7820.74641.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-36-g53e3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2010 17:57:20.0267 (UTC) FILETIME=[015BBDB0:01CA9EB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for bug #14845 (bugzilla.kernel.org). The
update_checksum() function in mm/kmemleak.c calls
kmemcheck_is_obj_initialised() before scanning an object. When
KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
the crc32_le() reads smaller intervals (32-bit) for which
kmemleak_is_obj_initialised() is may be false leading to a kmemcheck
warning.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Casteyde <casteyde.christian@free.fr>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 lib/Kconfig.kmemcheck |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.kmemcheck b/lib/Kconfig.kmemcheck
index 846e039..80660e9 100644
--- a/lib/Kconfig.kmemcheck
+++ b/lib/Kconfig.kmemcheck
@@ -75,7 +75,7 @@ config KMEMCHECK_SHADOW_COPY_SHIFT
 config KMEMCHECK_PARTIAL_OK
 	bool "kmemcheck: allow partially uninitialized memory"
 	depends on KMEMCHECK
-	default y
+	default y if !DEBUG_KMEMLEAK
 	help
 	  This option works around certain GCC optimizations that produce
 	  32-bit reads from 16-bit variables where the upper 16 bits are

