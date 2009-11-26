Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbZKZJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbZKZJ1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbZKZJ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:27:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38794 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760163AbZKZJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:27:14 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Junio C Hamano <gitster@pobox.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Teemu Likonen <tlikonen@iki.fi>, Jiri Kosina <jkosina@suse.cz>,
       Dan Carpenter <error27@gmail.com>, Martin Olsson <martin@minimum.se>,
       linux-doc@vger.kernel.org
Subject: [PATCH RFC] Codingstyle: allow omitting braces for all single statement branches
Date: Thu, 26 Nov 2009 10:26:58 +0100
Message-Id: <1259227618-1466-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
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

Grepping for "} else$" in v2.6.32-rc8 yields 6440 hits.  So this seems
to be common practice and should be allowed.  checkpatch doesn't warn
about both variants.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Junio C Hamano <gitster@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Teemu Likonen <tlikonen@iki.fi>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Martin Olsson <martin@minimum.se>
Cc: linux-doc@vger.kernel.org
---
 Documentation/CodingStyle |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 8bb3723..84563c6 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -168,15 +168,23 @@ Do not unnecessarily use braces where a single statement will do.
 if (condition)
 	action();
 
-This does not apply if one branch of a conditional statement is a single
-statement. Use braces in both branches.
-
-if (condition) {
-	do_this();
-	do_that();
-} else {
-	otherwise();
-}
+If not all branches of a conditional statement are single statements you might
+use braces for both branches.
+
+	if (condition) {
+		do_this();
+		do_that();
+	} else
+		otherwise();
+
+or
+
+	if (condition) {
+		do_this();
+		do_that();
+	} else {
+		otherwise();
+	}
 
 		3.1:  Spaces
 
-- 
1.6.5.2

