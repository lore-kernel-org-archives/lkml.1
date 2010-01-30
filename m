Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409Ab0A3Utx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0A3Utx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543Ab0A3Utw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:49:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0A3Utv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:49:51 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/7] modpost: define ALL_XYX{IN,EX}IT_SECTIONS
Date: Sat, 30 Jan 2010 21:46:47 +0100
Message-Id: <1264884412-6173-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
References: <20100130204425.GA16345@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PTX-Original-Recipient: ukl@pengutronix.de
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
[resend to lkml as it blocked the original mail because of a triple-X in
the subject, fixed to read 'XYX']

 scripts/mod/modpost.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 713b62e..dbab53a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -781,10 +781,13 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_EXIT_TEXT_SECTIONS \
 	".exit.text$", ".devexit.text$", ".cpuexit.text$", ".memexit.text$"
 
-#define ALL_INIT_SECTIONS INIT_SECTIONS, DEV_INIT_SECTIONS, \
-	CPU_INIT_SECTIONS, MEM_INIT_SECTIONS
-#define ALL_EXIT_SECTIONS EXIT_SECTIONS, DEV_EXIT_SECTIONS, \
-	CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS
+#define ALL_XXXINIT_SECTIONS DEV_INIT_SECTIONS, CPU_INIT_SECTIONS, \
+	MEM_INIT_SECTIONS
+#define ALL_XXXEXIT_SECTIONS DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, \
+	MEM_EXIT_SECTIONS
+
+#define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
+#define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
 #define DATA_SECTIONS ".data$", ".data.rel$"
 #define TEXT_SECTIONS ".text$"
@@ -876,7 +879,7 @@ const struct sectioncheck sectioncheck[] = {
 },
 /* Do not reference init code/data from devinit/cpuinit/meminit code/data */
 {
-	.fromsec = { DEV_INIT_SECTIONS, CPU_INIT_SECTIONS, MEM_INIT_SECTIONS, NULL },
+	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_INIT,
 },
@@ -894,7 +897,7 @@ const struct sectioncheck sectioncheck[] = {
 },
 /* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
 {
-	.fromsec = { DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
+	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_EXIT,
 },
-- 
1.6.6


