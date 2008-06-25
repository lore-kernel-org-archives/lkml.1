Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbYFYVpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbYFYVpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYFYVpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:45:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33880 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYFYVpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:45:39 -0400
Subject: [patch] x86: shift bits the right way in native_read_tscp
From: Max Asbock <masbock@us.ibm.com>
To: gcosta@redhat.com, tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 25 Jun 2008 14:45:28 -0700
Message-Id: <1214430328.20425.20.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

native_read_tscp shifts the bits in the high order value in the wrong direction,
the attached patch fixes that. 

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>

diff -pburN linux/include/asm-x86/msr.h linux.rdtscp/include/asm-x86/msr.h
--- linux/include/asm-x86/msr.h	2008-06-20 11:51:17.000000000 -0700
+++ linux.rdtscp/include/asm-x86/msr.h	2008-06-25 14:26:35.000000000 -0700
@@ -18,7 +18,7 @@ static inline unsigned long long native_
 	unsigned long low, high;
 	asm volatile(".byte 0x0f,0x01,0xf9"
 		     : "=a" (low), "=d" (high), "=c" (*aux));
-	return low | ((u64)high >> 32);
+	return low | ((u64)high << 32);
 }
 
 /*


---
Max


