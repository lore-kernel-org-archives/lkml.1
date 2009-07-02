Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZGBPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZGBPVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbZGBPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:21:09 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:58300 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGBPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hRGD4ER6s2KtDilNSc+GGC4kotFcCdsF7xFsgitechJ2pgUbK3law+aeq4kO1BlA62
         gu6GxB/5b4eN7OXEjRbGtEqndYYGkG0LdOyEUS8E7TWseLv4YiycjRMRrRWj22KZfnf1
         3FU+9Fv+I4w/Rre6neSX/tTbkKdEcEIGuzsLE=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org, Jason Wessel <jason.wessel@windriver.com>
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 04/16] [loongson] pm: Remove redundant source code
Date: Thu,  2 Jul 2009 23:20:56 +0800
Message-Id: <93ba7839f73d96de29fa76647ca1fe90012a021c.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

the implmentation of loongson2e_power_off and loongson2e_halt is
almostly the same, just reserve one of them.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/lemote/lm2e/reset.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/mips/lemote/lm2e/reset.c b/arch/mips/lemote/lm2e/reset.c
index 099387a..47ff506 100644
--- a/arch/mips/lemote/lm2e/reset.c
+++ b/arch/mips/lemote/lm2e/reset.c
@@ -28,14 +28,9 @@ static void loongson2e_halt(void)
 	while (1) ;
 }
 
-static void loongson2e_power_off(void)
-{
-	loongson2e_halt();
-}
-
 void mips_reboot_setup(void)
 {
 	_machine_restart = loongson2e_restart;
 	_machine_halt = loongson2e_halt;
-	pm_power_off = loongson2e_power_off;
+	pm_power_off = loongson2e_halt;
 }
-- 
1.6.2.1

