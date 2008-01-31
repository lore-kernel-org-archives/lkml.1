Return-Path: <linux-kernel-owner+w=401wt.eu-S1765097AbYAaHD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765097AbYAaHD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYAaHDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:03:18 -0500
Received: from ozlabs.org ([203.10.76.45]:59615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbYAaHDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:03:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] lguest: fix mis-merge against hpa's TSS renaming
Date: Thu, 31 Jan 2008 18:00:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "H. Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801311800.48359.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/lguest/x86/core.c: In function ‘copy_in_guest_info’:
drivers/lguest/x86/core.c:97: error: ‘struct x86_hw_tss’ has no member named ‘esp1’

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r bf3a09b5070a drivers/lguest/x86/core.c
--- a/drivers/lguest/x86/core.c	Thu Jan 31 14:50:43 2008 +1100
+++ b/drivers/lguest/x86/core.c	Thu Jan 31 17:58:44 2008 +1100
@@ -94,7 +94,7 @@ static void copy_in_guest_info(struct lg
 	/* Set up the two "TSS" members which tell the CPU what stack to use
 	 * for traps which do directly into the Guest (ie. traps at privilege
 	 * level 1). */
-	pages->state.guest_tss.esp1 = cpu->esp1;
+	pages->state.guest_tss.sp1 = cpu->esp1;
 	pages->state.guest_tss.ss1 = cpu->ss1;
 
 	/* Copy direct-to-Guest trap entries. */
