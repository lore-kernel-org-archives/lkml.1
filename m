Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYHXJEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYHXJEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYHXJDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYHXJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZBpsEJP0mAKvJ9XM1YdozGDSdlhvi8QxUm1AAPBJlC0W4UUcn11xvKdur6jWJ6N9M1
         5Umti/bY6x4lXd9v3MOlWaf7t14XdFW3qdiCrDUpsQZX2T9k3XU9hB4Zmn/1EoOw86Kp
         XOkL8EeeNG73RmwoIHd8ghZyT/vyM8mf/UMio=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/18] x86: apic - unify setup_apicpmtimer
Date: Sun, 24 Aug 2008 02:01:41 -0700
Message-Id: <1219568516-681-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |   10 ++++++++++
 arch/x86/kernel/apic_64.c |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index c168cec..cca72da 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1774,6 +1774,16 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
+#ifdef CONFIG_X86_64
+static __init int setup_apicpmtimer(char *s)
+{
+	apic_calibrate_pmtmr = 1;
+	notsc_setup(NULL);
+	return 0;
+}
+__setup("apicpmtimer", setup_apicpmtimer);
+#endif
+
 static int __init apic_set_verbosity(char *arg)
 {
 	if (!arg)  {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index bb46711..ddc5b24 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1810,6 +1810,7 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
+#ifdef CONFIG_X86_64
 static __init int setup_apicpmtimer(char *s)
 {
 	apic_calibrate_pmtmr = 1;
@@ -1817,6 +1818,7 @@ static __init int setup_apicpmtimer(char *s)
 	return 0;
 }
 __setup("apicpmtimer", setup_apicpmtimer);
+#endif
 
 static int __init apic_set_verbosity(char *arg)
 {
-- 
1.5.4.5

