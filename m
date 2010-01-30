Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136Ab0A3UrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0A3UrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407Ab0A3UrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43906 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0A3UrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:02 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] modpost: give most mismatch constants a better name
Date: Sat, 30 Jan 2010 21:46:48 +0100
Message-Id: <1264884412-6173-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
References: <20100130204425.GA16345@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/mod/modpost.c |   56 ++++++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index dbab53a..598d54a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -836,14 +836,14 @@ static const char *linker_symbols[] =
 
 enum mismatch {
 	NO_MISMATCH,
-	TEXT_TO_INIT,
-	DATA_TO_INIT,
-	TEXT_TO_EXIT,
-	DATA_TO_EXIT,
-	XXXINIT_TO_INIT,
-	XXXEXIT_TO_EXIT,
-	INIT_TO_EXIT,
-	EXIT_TO_INIT,
+	TEXT_TO_ANY_INIT,
+	DATA_TO_ANY_INIT,
+	TEXT_TO_ANY_EXIT,
+	DATA_TO_ANY_EXIT,
+	XXXINIT_TO_SOME_INIT,
+	XXXEXIT_TO_SOME_EXIT,
+	ANY_INIT_TO_ANY_EXIT,
+	ANY_EXIT_TO_ANY_INIT,
 	EXPORT_TO_INIT_EXIT,
 };
 
@@ -860,70 +860,70 @@ const struct sectioncheck sectioncheck[] = {
 {
 	.fromsec = { TEXT_SECTIONS, NULL },
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
-	.mismatch = TEXT_TO_INIT,
+	.mismatch = TEXT_TO_ANY_INIT,
 },
 {
 	.fromsec = { DATA_SECTIONS, NULL },
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
-	.mismatch = DATA_TO_INIT,
+	.mismatch = DATA_TO_ANY_INIT,
 },
 {
 	.fromsec = { TEXT_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
-	.mismatch = TEXT_TO_EXIT,
+	.mismatch = TEXT_TO_ANY_EXIT,
 },
 {
 	.fromsec = { DATA_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
-	.mismatch = DATA_TO_EXIT,
+	.mismatch = DATA_TO_ANY_EXIT,
 },
 /* Do not reference init code/data from devinit/cpuinit/meminit code/data */
 {
 	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_INIT,
+	.mismatch = XXXINIT_TO_SOME_INIT,
 },
 /* Do not reference cpuinit code/data from meminit code/data */
 {
 	.fromsec = { MEM_INIT_SECTIONS, NULL },
 	.tosec   = { CPU_INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_INIT,
+	.mismatch = XXXINIT_TO_SOME_INIT,
 },
 /* Do not reference meminit code/data from cpuinit code/data */
 {
 	.fromsec = { CPU_INIT_SECTIONS, NULL },
 	.tosec   = { MEM_INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_INIT,
+	.mismatch = XXXINIT_TO_SOME_INIT,
 },
 /* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
 {
 	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_EXIT,
+	.mismatch = XXXEXIT_TO_SOME_EXIT,
 },
 /* Do not reference cpuexit code/data from memexit code/data */
 {
 	.fromsec = { MEM_EXIT_SECTIONS, NULL },
 	.tosec   = { CPU_EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_EXIT,
+	.mismatch = XXXEXIT_TO_SOME_EXIT,
 },
 /* Do not reference memexit code/data from cpuexit code/data */
 {
 	.fromsec = { CPU_EXIT_SECTIONS, NULL },
 	.tosec   = { MEM_EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_EXIT,
+	.mismatch = XXXEXIT_TO_SOME_EXIT,
 },
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
-	.mismatch = INIT_TO_EXIT,
+	.mismatch = ANY_INIT_TO_ANY_EXIT,
 },
 /* Do not use init code/data from exit code */
 {
 	.fromsec = { ALL_EXIT_SECTIONS, NULL },
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
-	.mismatch = EXIT_TO_INIT,
+	.mismatch = ANY_EXIT_TO_ANY_INIT,
 },
 /* Do not export init/exit functions or data */
 {
@@ -1190,7 +1190,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 	     tosym, to_p);
 
 	switch (mismatch) {
-	case TEXT_TO_INIT:
+	case TEXT_TO_ANY_INIT:
 		fprintf(stderr,
 		"The function %s%s() references\n"
 		"the %s %s%s%s.\n"
@@ -1200,7 +1200,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		to, sec2annotation(tosec), tosym, to_p,
 		fromsym, sec2annotation(tosec), tosym);
 		break;
-	case DATA_TO_INIT: {
+	case DATA_TO_ANY_INIT: {
 		const char **s = symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1214,14 +1214,14 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		fprintf(stderr, "\n");
 		break;
 	}
-	case TEXT_TO_EXIT:
+	case TEXT_TO_ANY_EXIT:
 		fprintf(stderr,
 		"The function %s() references a %s in an exit section.\n"
 		"Often the %s %s%s has valid usage outside the exit section\n"
 		"and the fix is to remove the %sannotation of %s.\n",
 		fromsym, to, to, tosym, to_p, sec2annotation(tosec), tosym);
 		break;
-	case DATA_TO_EXIT: {
+	case DATA_TO_ANY_EXIT: {
 		const char **s = symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1235,8 +1235,8 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		fprintf(stderr, "\n");
 		break;
 	}
-	case XXXINIT_TO_INIT:
-	case XXXEXIT_TO_EXIT:
+	case XXXINIT_TO_SOME_INIT:
+	case XXXEXIT_TO_SOME_EXIT:
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1246,7 +1246,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		to, sec2annotation(tosec), tosym, to_p,
 		tosym, fromsym, tosym);
 		break;
-	case INIT_TO_EXIT:
+	case ANY_INIT_TO_ANY_EXIT:
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1259,7 +1259,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		to, sec2annotation(tosec), tosym, to_p,
 		sec2annotation(tosec), tosym, to_p);
 		break;
-	case EXIT_TO_INIT:
+	case ANY_EXIT_TO_ANY_INIT:
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
-- 
1.6.6

