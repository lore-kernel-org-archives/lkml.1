Return-Path: <linux-kernel-owner+w=401wt.eu-S933858AbZJGAhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbZJGAhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933730AbZJGAhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:37:48 -0400
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:42748 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933327AbZJGAhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:37:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] init/main.c: fix symbol shadows noise
Date: Tue, 6 Oct 2009 20:37:17 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901DB797E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] init/main.c: fix symbol shadows noise
Thread-Index: AcpG5lJOjLw5nPN2Q/q6+Zc0hOxpvA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Oct 2009 00:37:10.0197 (UTC) FILETIME=[4E348E50:01CA46E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'call' is a static symbol used for initcall_debug.  This
same symbol name is used locally by a couple functions and produces
the following sparse warnings:

	warning: symbol 'call' shadows an earlier one

Fix this noise by renaming the local symbols.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/init/main.c b/init/main.c
index 7449819..19e564a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -696,10 +696,10 @@ asmlinkage void __init start_kernel(void)
 static void __init do_ctors(void)
 {
 #ifdef CONFIG_CONSTRUCTORS
-	ctor_fn_t *call = (ctor_fn_t *) __ctors_start;
+	ctor_fn_t *fn = (ctor_fn_t *) __ctors_start;
 
-	for (; call < (ctor_fn_t *) __ctors_end; call++)
-		(*call)();
+	for (; fn < (ctor_fn_t *) __ctors_end; fn++)
+		(*fn)();
 #endif
 }
 
@@ -760,10 +760,10 @@ extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
 
 static void __init do_initcalls(void)
 {
-	initcall_t *call;
+	initcall_t *fn;
 
-	for (call = __early_initcall_end; call < __initcall_end; call++)
-		do_one_initcall(*call);
+	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
+		do_one_initcall(*fn);
 
 	/* Make sure there is no pending stuff from the initcall sequence */
 	flush_scheduled_work();
@@ -791,10 +791,10 @@ static void __init do_basic_setup(void)
 
 static void __init do_pre_smp_initcalls(void)
 {
-	initcall_t *call;
+	initcall_t *fn;
 
-	for (call = __initcall_start; call < __early_initcall_end; call++)
-		do_one_initcall(*call);
+	for (fn = __initcall_start; fn < __early_initcall_end; fn++)
+		do_one_initcall(*fn);
 }
 
 static void run_init_process(char *init_filename) 
