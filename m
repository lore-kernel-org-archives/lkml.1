Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0A3Urz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0A3Urz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407Ab0A3Urv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43963 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0A3Uru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:50 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/7] modpost: don't allow *driver to reference .init.*
Date: Sat, 30 Jan 2010 21:46:52 +0100
Message-Id: <1264884412-6173-7-git-send-email-u.kleine-koenig@pengutronix.de>
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
 scripts/mod/modpost.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5dbe4db..3318692 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -862,11 +862,20 @@ const struct sectioncheck sectioncheck[] = {
 },
 {
 	.fromsec = { DATA_SECTIONS, NULL },
-	.tosec   = { ALL_INIT_SECTIONS, NULL },
+	.tosec   = { ALL_XXXINIT_SECTIONS, NULL },
 	.mismatch = DATA_TO_ANY_INIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 {
+	.fromsec = { DATA_SECTIONS, NULL },
+	.tosec   = { INIT_SECTIONS, NULL },
+	.mismatch = DATA_TO_ANY_INIT,
+	.symbol_white_list = {
+		"*_template", "*_timer", "*_sht", "*_ops",
+		"*_probe", "*_probe_one", "*_console", NULL
+	},
+},
+{
 	.fromsec = { TEXT_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
 	.mismatch = TEXT_TO_ANY_EXIT,
-- 
1.6.6

