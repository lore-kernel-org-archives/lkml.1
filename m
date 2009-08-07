Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbZHGUmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbZHGUmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933871AbZHGUmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:42:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbZHGUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:42:51 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: [PATCH 3/6] [ARM] msm: include linux/cache.h in proc_comm.c
Date: Fri,  7 Aug 2009 22:42:38 +0200
Message-Id: <1249677761-19470-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090807203939.GA19374@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a a build failure for 2.6.31-rc4-rt1 (ARCH=arm,
msm_defconfig):

  CC      arch/arm/mach-msm/proc_comm.o
/ptx/work/octopus/WORK_2_A/ukl/gsrc/linux-2.6/arch/arm/mach-msm/proc_comm.c:43: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__cacheline_aligned_in_smp'
/ptx/work/octopus/WORK_2_A/ukl/gsrc/linux-2.6/arch/arm/mach-msm/proc_comm.c: In function 'msm_proc_comm':
/ptx/work/octopus/WORK_2_A/ukl/gsrc/linux-2.6/arch/arm/mach-msm/proc_comm.c:76: error: 'proc_comm_lock' undeclared (first use in this function)
/ptx/work/octopus/WORK_2_A/ukl/gsrc/linux-2.6/arch/arm/mach-msm/proc_comm.c:76: error: (Each undeclared identifier is reported only once
/ptx/work/octopus/WORK_2_A/ukl/gsrc/linux-2.6/arch/arm/mach-msm/proc_comm.c:76: error: for each function it appears in.)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Brian Swetland <swetland@google.com>
---
 arch/arm/mach-msm/proc_comm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/proc_comm.c b/arch/arm/mach-msm/proc_comm.c
index 915ee70..e825c36 100644
--- a/arch/arm/mach-msm/proc_comm.c
+++ b/arch/arm/mach-msm/proc_comm.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/cache.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/io.h>
-- 
1.6.3.3

