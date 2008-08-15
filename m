Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYHOXpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYHOXpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbYHOXnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:43:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33084 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbYHOXnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T/fxq+BHJJlqqgExz6FsEcbNkWj+APYAXuUObWtlzDITa7AqTuip+6vFvhV7ibVtTF
         v/euxFlmv3q4JAnCVm7qb8oZAuR8830edNj+YbVta2lVDNzf3psqxiZCU/meXpdQucKv
         vwIU9Imt1sN6a3dEpSScUct1HdEQkBVAxfWs0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/7] x86: remve ioapic_force
Date: Fri, 15 Aug 2008 16:42:39 -0700
Message-Id: <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no user

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 6709393..cf89524 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1555,7 +1555,6 @@ static int __init apic_set_verbosity(char *str)
 {
 	if (str == NULL)  {
 		skip_ioapic_setup = 0;
-		ioapic_force = 1;
 		return 0;
 	}
 	if (strcmp("debug", str) == 0)
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index bb024d1..ca87077 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -63,8 +63,6 @@
 
 #define __apicdebuginit(type) static type __init
 
-int ioapic_force;
-
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index d76a083..2d970f6 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -40,8 +40,6 @@ extern void generic_apic_probe(void);
 extern unsigned int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
-extern int ioapic_force;
-
 extern int disable_apic;
 /*
  * Basic functions accessing APICs.
