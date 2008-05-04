Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYEDMjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYEDMjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYEDMja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:39:30 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbYEDMj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:39:29 -0400
Subject: [PATCH] stacktrace: don't crash on invalid stack trace structs
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@redhat.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 May 2008 14:39:21 +0200
Message-Id: <1209904761.4065.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the stacktrace printout code warn when the entries
pointer is unset rather than crashing when trying to access it in an
attempt to make it a bit more robust.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I was saving a stacktrace into an skb and forgot to copy it across skb
copies... Not sure if you want this, I have since fixed the code, but it
would have been easier had the kernel not crashed in an interrupt.

--- everything.orig/kernel/stacktrace.c	2008-05-04 14:02:14.000000000 +0200
+++ everything/kernel/stacktrace.c	2008-05-04 14:02:24.000000000 +0200
@@ -13,6 +13,9 @@ void print_stack_trace(struct stack_trac
 {
 	int i, j;
 
+	if (WARN_ON(!trace->entries))
+		return;
+
 	for (i = 0; i < trace->nr_entries; i++) {
 		unsigned long ip = trace->entries[i];
 


