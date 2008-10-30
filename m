Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYJ3PTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYJ3PTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYJ3PTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:19:00 -0400
Received: from mfo31.po.2iij.net ([210.128.50.52]:9858 "EHLO mfo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbYJ3PS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:18:59 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 11:18:59 EDT
Date: Fri, 31 Oct 2008 00:04:07 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: yoichi_yuasa@tripeaks.co.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Power Management support requires RTC_CLASS
Message-Id: <20081031000407.8f16beb0.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/built-in.o: In function `test_wakealarm':
linux/kernel/power/main.c:619: undefined reference to `rtc_read_time'
linux/kernel/power/main.c:619: relocation truncated to fit: R_MIPS_26 against `rtc_read_time'
linux/kernel/power/main.c:630: undefined reference to `rtc_set_alarm'
linux/kernel/power/main.c:630: relocation truncated to fit: R_MIPS_26 against `rtc_set_alarm'
linux/kernel/power/main.c:654: undefined reference to `rtc_set_alarm'
linux/kernel/power/main.c:654: relocation truncated to fit: R_MIPS_26 against `rtc_set_alarm'
kernel/built-in.o: In function `test_suspend':
linux/kernel/power/main.c:718: undefined reference to `rtc_class_open'
linux/kernel/power/main.c:718: relocation truncated to fit: R_MIPS_26 against `rtc_class_open'
linux/kernel/power/main.c:726: undefined reference to `rtc_class_close'
linux/kernel/power/main.c:726: relocation truncated to fit: R_MIPS_26 against `rtc_class_close'
kernel/built-in.o: In function `valid_state':
linux/kernel/power/main.c:403: undefined reference to `rtc_class'
kernel/built-in.o: In function `test_suspend':
linux/kernel/power/main.c:716: undefined reference to `rtc_class'

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/kernel/power/Kconfig linux/kernel/power/Kconfig
--- linux-orig/kernel/power/Kconfig	2008-10-22 09:41:32.154425163 +0900
+++ linux/kernel/power/Kconfig	2008-10-22 11:04:48.230018848 +0900
@@ -1,6 +1,7 @@
 config PM
 	bool "Power Management support"
 	depends on !IA64_HP_SIM
+	select RTC_CLASS
 	---help---
 	  "Power Management" means that parts of your computer are shut
 	  off or put into a power conserving "sleep" mode if they are not
