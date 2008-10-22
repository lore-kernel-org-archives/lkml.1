Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYJVPIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYJVPIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYJVPIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:08:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38369 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYJVPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:08:39 -0400
From: Viktor Rosendahl <viktor.rosendahl@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Make sure that any oops is flushed to the mtdoops console
Date: Wed, 22 Oct 2008 18:16:28 +0300
Message-Id: <1224688588-2665-2-git-send-email-viktor.rosendahl@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1224688588-2665-1-git-send-email-viktor.rosendahl@nokia.com>
References: <1224688588-2665-1-git-send-email-viktor.rosendahl@nokia.com>
X-OriginalArrivalTime: 22 Oct 2008 15:08:11.0869 (UTC) FILETIME=[000258D0:01C93458]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This used to work unpatched with older kernels, during the development phase
of mtdoops. Before commit e3e8a75d2acfc61ebf25524666a0a2c6abb0620c a space was
printed with console_loglevel set to 15, which probably flushed the oops
message as a side effect.

This is another patch from the Nokia N810 kernel.

Signed-off-by: Viktor Rosendahl <viktor.rosendahl@nokia.com>
---
 lib/bust_spinlocks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/bust_spinlocks.c b/lib/bust_spinlocks.c
index 486da62..9681d54 100644
--- a/lib/bust_spinlocks.c
+++ b/lib/bust_spinlocks.c
@@ -12,6 +12,7 @@
 #include <linux/tty.h>
 #include <linux/wait.h>
 #include <linux/vt_kern.h>
+#include <linux/console.h>
 
 
 void __attribute__((weak)) bust_spinlocks(int yes)
@@ -22,6 +23,7 @@ void __attribute__((weak)) bust_spinlocks(int yes)
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
+		console_unblank();
 		if (--oops_in_progress == 0)
 			wake_up_klogd();
 	}
-- 
1.5.6.5

