Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbZIEApz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbZIEApz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933928AbZIEApx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:45:53 -0400
Received: from mail.atheros.com ([12.36.123.2]:31881 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500AbZIEApA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:45:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <penberg@cs.helsinki.fi>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 5/5] kmemleak: fix sparse warning for static declarations
Date: Fri, 4 Sep 2009 17:44:54 -0700
Message-ID: <1252111494-7593-6-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes these sparse warnings:

mm/kmemleak.c:1179:6: warning: symbol 'start_scan_thread' was not declared. Should it be static?
mm/kmemleak.c:1194:6: warning: symbol 'stop_scan_thread' was not declared. Should it be static?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d078621..9b14e24 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1269,7 +1269,7 @@ static int kmemleak_scan_thread(void *arg)
  * Start the automatic memory scanning thread. This function must be called
  * with the scan_mutex held.
  */
-void start_scan_thread(void)
+static void start_scan_thread(void)
 {
 	if (scan_thread)
 		return;
@@ -1284,7 +1284,7 @@ void start_scan_thread(void)
  * Stop the automatic memory scanning thread. This function must be called
  * with the scan_mutex held.
  */
-void stop_scan_thread(void)
+static void stop_scan_thread(void)
 {
 	if (scan_thread) {
 		kthread_stop(scan_thread);
-- 
1.6.3.3

