Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZLCWZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZLCWZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZLCWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:25:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZLCWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:28 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] tip-lib: optimize get_auto_branches ...
Date: Thu,  3 Dec 2009 23:24:40 +0100
Message-Id: <1259879084-20147-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259879084-20147-4-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
 <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-4-git-send-email-u.kleine-koenig@pengutronix.de>
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

... and use it in get_all_auto_branches instead of coding it again

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .tip/bin/tip-lib |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/.tip/bin/tip-lib b/.tip/bin/tip-lib
index 805c8e2..1311d63 100644
--- a/.tip/bin/tip-lib
+++ b/.tip/bin/tip-lib
@@ -8,8 +8,7 @@ get_current_branch() {
 }
 
 get_auto_branches() {
-
-    git ls-tree  tip -- .tip/auto-branches/ | sed "s@.*tip/auto-branches/@@"
+    git ls-tree --name-only --full-name tip:.tip/auto-branches/
 }
 
 get_auto_branches_no_latest() {
@@ -19,8 +18,7 @@ get_auto_branches_no_latest() {
 
 get_all_auto_branches() {
 
-    AB=`git ls-tree  tip -- .tip/auto-branches/ | sed "s@.*tip/auto-branches/@@"`
-    for B in $AB
+    for B in $(get_auto_branches)
     do
 	echo $B
 	echo $B"-base"
-- 
1.6.5.2

