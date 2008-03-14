Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYCNVeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYCNVeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYCNVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:33:34 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:58399 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbYCNVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:33:33 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu,
       harvey.harrison@gmail.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/6] Add semaphore.h to kernel_lock.c
Date: Fri, 14 Mar 2008 16:44:49 -0400
Message-Id: <1205527493-5740-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205527493-5740-1-git-send-email-matthew@wil.cx>
References: <20080314204248.GV613@parisc-linux.org>
 <1205527493-5740-1-git-send-email-matthew@wil.cx>
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
1.5.4.3

