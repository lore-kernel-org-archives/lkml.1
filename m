Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYHRQtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYHRQtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYHRQp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:25010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYHRQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CYs7iYJ4eavphYc2O1QZ46ulE79avxbT7wPjCzqu40KAI/iqMO40RzyIbtGw4p+YYe
         MsZMrv+MpEhp1JnImGeoj32PXVjcISlN/asSAQH2fR9FbdbqfdluOPB1P0IJ8Bb+o2Kl
         E0LWKNOs2Japq2LwzzenoV+GcbOQOSxv/6z5Q=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 14/15] x86: apic - rearrange parse_lapic_timer_c2_ok
Date: Mon, 18 Aug 2008 20:46:02 +0400
Message-Id: <84b9f50fec6af55861a44b135b1ade7f4224b4d4.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 5680bda..885e306 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1752,6 +1752,13 @@ static int __init setup_nolapic(char *arg)
 }
 early_param("nolapic", setup_nolapic);
 
+static int __init parse_lapic_timer_c2_ok(char *arg)
+{
+	local_apic_timer_c2_ok = 1;
+	return 0;
+}
+early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
+
 static int __init parse_disable_apic_timer(char *arg)
 {
 	disable_apic_timer = 1;
@@ -1766,13 +1773,6 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
-static int __init parse_lapic_timer_c2_ok(char *arg)
-{
-	local_apic_timer_c2_ok = 1;
-	return 0;
-}
-early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
-
 static int __init apic_set_verbosity(char *arg)
 {
 	if (!arg)  {
-- 
1.6.0.rc1.34.g0fe8c

