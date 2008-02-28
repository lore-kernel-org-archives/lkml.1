Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbYB1Grj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbYB1Grj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYB1Gpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:50 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52733 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753107AbYB1Gpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:44 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 02/12] Add semaphore.h to kernel_lock.c
Date: Thu, 28 Feb 2008 01:33:51 -0500
Message-Id: <1204180441-8540-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-1-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_lock.c uses DECLARE_MUTEX, up() and down() without explicitly
including asm/semaphore.h.  This is fragile and leaves it vulnerable
to breakage during header reorganisations.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 lib/kernel_lock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 812dbf0..fbc11a3 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -8,6 +8,7 @@
 #include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <asm/semaphore.h>
 
 /*
  * The 'big kernel semaphore'
-- 
1.5.4.1

