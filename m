Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZLJNIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZLJNIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbZLJNID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:08:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbZLJNIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:08:00 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, damm@igel.co.jp, hsweeten@visionengravers.com,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 2/4] clockevents: convert clockevents_do_notify to int
Date: Thu, 10 Dec 2009 21:07:37 +0800
Message-Id: <1260450459-18072-3-git-send-email-dfeng@redhat.com>
In-Reply-To: <1260450459-18072-2-git-send-email-dfeng@redhat.com>
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com>
 <1260450459-18072-2-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to get results from notify CLOCK_EVT_NOTIFY_ADD, so convert
clockevents_do_notify to int, used by later patches.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 kernel/time/clockevents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 1896d9d..980c2c0 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -152,9 +152,9 @@ int clockevents_register_notifier(struct notifier_block *nb)
  * Notify about a clock event change. Called with clockevents_lock
  * held.
  */
-static void clockevents_do_notify(unsigned long reason, void *dev)
+static int clockevents_do_notify(unsigned long reason, void *dev)
 {
-	raw_notifier_call_chain(&clockevents_chain, reason, dev);
+	return raw_notifier_call_chain(&clockevents_chain, reason, dev);
 }
 
 /*
-- 
1.6.5.2

