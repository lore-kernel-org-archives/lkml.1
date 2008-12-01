Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYLAM5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYLAM5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYLAM4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:56:23 -0500
Received: from ozlabs.org ([203.10.76.45]:44062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbYLAM4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:56:22 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:26:17 +1030
Subject: [RFC 6/8] params: move core_param() parsing to before setup_arch.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012326.17801.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -563,6 +563,9 @@ asmlinkage void __init start_kernel(void
 asmlinkage void __init start_kernel(void)
 {
 	arch_get_boot_command_line();
+	parse_args("Core params", boot_command_line, __start___core_param,
+		   __stop___core_param - __start___core_param,
+		   unknown_core_ok, true);
 
 	smp_setup_processor_id();
 
@@ -592,9 +595,6 @@ asmlinkage void __init start_kernel(void
 	setup_arch();
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line();
-	parse_args("Core params", boot_command_line, __start___core_param,
-		   __stop___core_param - __start___core_param,
-		   unknown_core_ok, true);
 
 	unwind_setup();
 	setup_per_cpu_areas();


