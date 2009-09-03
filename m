Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZICFgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZICFgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZICFfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:35:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45165 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZICFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:35:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: catalin.marinas@arm.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 5/5] kmemleak: fix sparse warning for static declarations
Date: Thu,  3 Sep 2009 01:35:40 -0400
Message-Id: <1251956140-5499-6-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes these sparse warnings:

mm/kmemleak.c:1179:6: warning: symbol 'start_scan_thread' was not declared. Should it be static?
mm/kmemleak.c:1194:6: warning: symbol 'stop_scan_thread' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 24e7a84..262e155 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1176,7 +1176,7 @@ static int kmemleak_scan_thread(void *arg)
  * Start the automatic memory scanning thread. This function must be called
  * with the scan_mutex held.
  */
-void start_scan_thread(void)
+static void start_scan_thread(void)
 {
 	if (scan_thread)
 		return;
@@ -1191,7 +1191,7 @@ void start_scan_thread(void)
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

