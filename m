Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbYJTDVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbYJTDVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYJTDUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:20:44 -0400
Received: from ozlabs.org ([203.10.76.45]:33060 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYJTDUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:20:43 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 19 Oct 2008 22:20:36 -0500
Subject: [PATCH 5/5] Make panic= and panic_on_oops into core_params
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201420.36136.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows them to be examined and set after boot, plus means they
actually give errors if they are misused (eg. panic=yes).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/panic.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -r 660a97679013 kernel/panic.c
--- a/kernel/panic.c	Thu Aug 28 11:46:29 2008 +1000
+++ b/kernel/panic.c	Thu Aug 28 11:51:50 2008 +1000
@@ -33,13 +33,6 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
-
-static int __init panic_setup(char *str)
-{
-	panic_timeout = simple_strtoul(str, NULL, 0);
-	return 1;
-}
-__setup("panic=", panic_setup);
 
 static long no_blink(long time)
 {
@@ -187,13 +180,6 @@ void add_taint(unsigned flag)
 }
 EXPORT_SYMBOL(add_taint);
 
-static int __init pause_on_oops_setup(char *str)
-{
-	pause_on_oops = simple_strtoul(str, NULL, 0);
-	return 1;
-}
-__setup("pause_on_oops=", pause_on_oops_setup);
-
 static void spin_msec(int msecs)
 {
 	int i;
@@ -353,3 +339,6 @@ void __stack_chk_fail(void)
 }
 EXPORT_SYMBOL(__stack_chk_fail);
 #endif
+
+core_param(panic, panic_timeout, int, 0644);
+core_param(pause_on_oops, pause_on_oops, int, 0644);

