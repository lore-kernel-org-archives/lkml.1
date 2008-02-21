Return-Path: <linux-kernel-owner+w=401wt.eu-S1764437AbYBUTvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764437AbYBUTvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYBUTux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:50:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:47058 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYBUTuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=uqbCGTQHhGFFzuOlaAOkWFCj2Jyz7c8IObTO2cVONObDA7Jd2BknMUl7GZz+aCWA/G99hNx8fueDjUHpGI1mhEDJdNQozD6uWkulCE7C2J14CFKc0FthvimavuUTzgsHR63d55vWSoCWiOn8f4wapNXjlWYGMUjpccmCIsGOh4c=
Date: Thu, 21 Feb 2008 22:50:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: cleanup - use PAGE_SIZE instead of numeric constant
	in boot code
Message-ID: <20080221195022.GA6772@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces 4096 numeric constant with PAGE_SIZE macro.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Text segments of old and new files *are* the same so
it wouldn't break current kernel.

 main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


Index: linux-2.6.git/arch/x86/boot/main.c
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/main.c	2008-02-09 22:27:13.000000000 +0300
+++ linux-2.6.git/arch/x86/boot/main.c	2008-02-21 22:28:10.000000000 +0300
@@ -14,6 +14,7 @@
  * Main module for the real-mode kernel code
  */
 
+#include <asm/page.h>
 #include "boot.h"
 
 struct boot_params boot_params __attribute__((aligned(16)));
@@ -36,7 +37,7 @@ static void copy_boot_params(void)
 	const struct old_cmdline * const oldcmd =
 		(const struct old_cmdline *)OLD_CL_ADDRESS;
 
-	BUILD_BUG_ON(sizeof boot_params != 4096);
+	BUILD_BUG_ON(sizeof boot_params != PAGE_SIZE);
 	memcpy(&boot_params.hdr, &hdr, sizeof hdr);
 
 	if (!boot_params.hdr.cmd_line_ptr &&
