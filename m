Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbYCSVnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbYCSVnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764699AbYCSULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:11:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:32043 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764698AbYCSULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:11:54 -0400
From: Denis Cheng <crquan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@woody.linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: vm.drop_caches should be writable only
Date: Wed, 19 Mar 2008 19:19:02 +0800
Message-Id: <1205925542-14459-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file's functionality is to tell the system to do a cache reclaiming,
the possible value to write to it is only 1, 2 or 3, reading from it will
get the last value written to it, that's meaingless.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
Reference to 7e3e0360, which also changed some sysctl value from 0644 to 0200.

 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2a2d68..f50926a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -980,7 +980,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "drop_caches",
 		.data		= &sysctl_drop_caches,
 		.maxlen		= sizeof(int),
-		.mode		= 0644,
+		.mode		= 0200,
 		.proc_handler	= drop_caches_sysctl_handler,
 		.strategy	= &sysctl_intvec,
 	},
-- 
1.5.4.4

