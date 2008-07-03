Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYGCMbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYGCMbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYGCMbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:31:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:10856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYGCMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:31:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,742,1204531200"; 
   d="scan'208";a="584649670"
Subject: [PATCH 2/2] run sysrq poweroff on boot cpu
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, harbour@sfinx.od.ua
Content-Type: text/plain
Date: Thu, 03 Jul 2008 15:56:54 +0800
Message-Id: <1215071814.3214.1.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

schedule sysrq poweroff on boot cpu.

sysrq poweroff needs to disable nonboot cpus, and we need to run this
on boot cpu to avoid any recursion.
http://bugzilla.kernel.org/show_bug.cgi?id=10897

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
tested-by: Rus <harbour@sfinx.od.ua>
---
 kernel/power/poweroff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/poweroff.c
===================================================================
--- linux-2.6.orig/kernel/power/poweroff.c	2008-06-30 16:01:35.000000000 +0800
+++ linux-2.6/kernel/power/poweroff.c	2008-07-03 10:50:05.000000000 +0800
@@ -25,7 +25,8 @@
 
 static void handle_poweroff(int key, struct tty_struct *tty)
 {
-	schedule_work(&poweroff_work);
+	/* run sysrq poweroff on boot cpu */
+	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
 }
 
 static struct sysrq_key_op	sysrq_poweroff_op = {


