Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXG3P0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXG3P0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXG3P0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:26:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbXG3P0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:26:00 -0400
Subject: [PATCH] Fix msr register allocation
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 30 Jul 2007 12:25:54 -0300
Message-Id: <1185809155.4347.20.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the value in ret will go through a return statement,
it does not need to be put in eax register directly. Instead,
we let the compiler do his job and choose what to do with it,
potentially getting a better register allocation.
    
Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

diff --git a/include/asm-i386/msr.h b/include/asm-i386/msr.h
index df21ea0..cc4263c 100644
--- a/include/asm-i386/msr.h
+++ b/include/asm-i386/msr.h
@@ -54,7 +54,7 @@ static inline int native_write_msr_safe(unsigned int msr,
 		     "   .align 4\n\t"
 		     "   .long 	2b,3b\n\t"
 		     ".previous"
-		     : "=a" (err)
+		     : "=r" (err)
 		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val>>32)),
 		       "i" (-EFAULT));
 	return err;


