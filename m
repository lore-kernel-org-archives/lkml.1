Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYKASUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYKASUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYKASUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:20:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYKASUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:20:10 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] PM_TEST_SUSPEND should depend on RTC_CLASS, not RTC_LIB
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KwL4z-0000U5-Eq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 01 Nov 2008 18:20:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Insufficient dependency - we really want CONFIG_RTC_CLASS=y there.
That will give us CONFIG_RTC_LIB=y, so the old dependency can be
simply replaced.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/power/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index dcd165f..23bd4da 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -96,7 +96,7 @@ config SUSPEND
 
 config PM_TEST_SUSPEND
 	bool "Test suspend/resume and wakealarm during bootup"
-	depends on SUSPEND && PM_DEBUG && RTC_LIB=y
+	depends on SUSPEND && PM_DEBUG && RTC_CLASS=y
 	---help---
 	This option will let you suspend your machine during bootup, and
 	make it wake up a few seconds later using an RTC wakeup alarm.
-- 
1.5.6.5


