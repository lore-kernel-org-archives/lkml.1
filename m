Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZKDJGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZKDJGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZKDJGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:06:17 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63307 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZKDJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G1JZ2U3GTEbXD0jykF8admYWCm9q4wgYugbeMG+MwLa7ibPmwxSFYTg65LkRFHLXs6
         9wRYpqpBkZ20Um64J3/fByhZjkLborMbPOz4ZIeXfrQKI9i1tm2bQ27j9RWv2kWNkmIN
         5bwmp/a0w1Pf3xAkTHT8w2EdF4szxW2Agiwqc=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: [PATCH -queue v0 5/6] [loongson] rtc: enable legacy RTC driver on fuloong2f
Date: Wed,  4 Nov 2009 17:06:07 +0800
Message-Id: <e13ed33a99dbf14f223360d414aa2b2c5caa9b1f.1257325319.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1257325319.git.wuzhangjin@gmail.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTC_LIB is selected by MIPS by default, and therefore, the legacy RTC driver is
disabled. but fortunately, RTC_LIB not works on fulong, so, enabling the legcy
RTC driver is needed, otherwise, the tools like hwclock will not work.

because loongson family machines, including fuloong2e, fuloong2f and
yeeloong2f need to enable legacy RTC driver, so we use MACH_LOONGSON
here.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8417357..6a9bdda 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -7,7 +7,7 @@ config MIPS
 	select HAVE_ARCH_KGDB
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
-	select RTC_LIB if !LEMOTE_FULOONG2E
+	select RTC_LIB if !MACH_LOONGSON
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
-- 
1.6.2.1

