Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbZKYVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbZKYVjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbZKYVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:39:13 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58051 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759380AbZKYVjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:10 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH 7/8] Blackfin: fix memset in smp_send_reschedule() and -stop()
Date: Wed, 25 Nov 2009 16:39:06 -0500
Message-Id: <1259185147-31999-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

To set zeroes the sizeof the struct should be used rather
than sizeof the pointer, kzalloc does that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/smp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index d98585f..d92b168 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -276,10 +276,9 @@ void smp_send_reschedule(int cpu)
 	if (cpu_is_offline(cpu))
 		return;
 
-	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
 	if (!msg)
 		return;
-	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_RESCHEDULE;
 
@@ -305,10 +304,9 @@ void smp_send_stop(void)
 	if (cpus_empty(callmap))
 		return;
 
-	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
 	if (!msg)
 		return;
-	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_CPU_STOP;
 
-- 
1.6.5.3

