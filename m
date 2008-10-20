Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYJTDUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYJTDUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYJTDU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:20:27 -0400
Received: from ozlabs.org ([203.10.76.45]:33058 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYJTDU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:20:27 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 19 Oct 2008 22:20:25 -0500
Subject: [PATCH 4/5] Make initcall_debug a core_param
Cc: Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201420.25510.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the one I really wanted: now it effects module loading, it
makes sense to be able to flip it after boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 init/main.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -r c498374c07e1 init/main.c
--- a/init/main.c	Mon Aug 25 15:06:35 2008 +1000
+++ b/init/main.c	Mon Aug 25 17:20:43 2008 +1000
@@ -692,13 +692,7 @@ asmlinkage void __init start_kernel(void
 }
 
 static int initcall_debug;
-
-static int __init initcall_debug_setup(char *str)
-{
-	initcall_debug = 1;
-	return 1;
-}
-__setup("initcall_debug", initcall_debug_setup);
+core_param(initcall_debug, initcall_debug, bool, 0644);
 
 int do_one_initcall(initcall_t fn)
 {

