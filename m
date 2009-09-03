Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZICBlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZICBlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZICBlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:41:12 -0400
Received: from mail.atheros.com ([12.36.123.2]:53917 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbZICBlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:41:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <penberg@cs.helsinki.fi>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/5] kmemleak: fix sparse warning for static declarations
Date: Wed, 2 Sep 2009 18:40:59 -0700
Message-ID: <1251942059-21448-6-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 09ddf9c..38496ab 100644
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

