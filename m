Return-Path: <linux-kernel-owner+w=401wt.eu-S1765441AbYASCBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765441AbYASCBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 21:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764580AbYASB7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:59:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764291AbYASB72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:59:28 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 5/6] export check_tsc_unstable
Date: Fri, 18 Jan 2008 23:59:09 -0200
Message-Id: <1200707976298-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1200707971507-git-send-email-gcosta@redhat.com>
References: <1200707950911-git-send-email-gcosta@redhat.com> <12007079562927-git-send-email-gcosta@redhat.com> <12007079613080-git-send-email-gcosta@redhat.com> <12007079663929-git-send-email-gcosta@redhat.com> <1200707971507-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporrt check_tsc_unstable function as GPL symbol. lguest is
a user of it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tsc_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index c62f3b6..947554d 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -92,10 +92,12 @@ sched_clock(void) __attribute__((alias("native_sched_clock")));
 
 static int tsc_unstable;
 
-inline int check_tsc_unstable(void)
+int check_tsc_unstable(void)
 {
 	return tsc_unstable;
 }
+EXPORT_SYMBOL_GPL(check_tsc_unstable);
+
 #ifdef CONFIG_CPU_FREQ
 
 /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
-- 
1.5.0.6

