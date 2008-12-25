Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbYLYGs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbYLYGs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 01:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYLYGst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 01:48:49 -0500
Received: from ozlabs.org ([203.10.76.45]:38774 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYLYGst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 01:48:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: remove impossible test in mtrr/main.c
Date: Thu, 25 Dec 2008 17:18:43 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812251718.44233.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

enable_mtrr_cleanup is static, and is never set to anything but 0 or 1.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -823,16 +823,14 @@ static int enable_mtrr_cleanup __initdat
 
 static int __init disable_mtrr_cleanup_setup(char *str)
 {
-	if (enable_mtrr_cleanup != -1)
-		enable_mtrr_cleanup = 0;
+	enable_mtrr_cleanup = 0;
 	return 0;
 }
 early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
 
 static int __init enable_mtrr_cleanup_setup(char *str)
 {
-	if (enable_mtrr_cleanup != -1)
-		enable_mtrr_cleanup = 1;
+	enable_mtrr_cleanup = 1;
 	return 0;
 }
 early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
