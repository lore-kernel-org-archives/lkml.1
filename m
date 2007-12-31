Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbXLaSMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbXLaSMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXLaSMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:12:49 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55833 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbXLaSMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:12:48 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>
Subject: asm-x86/byteorder.h: clean up for userspace
Date: Mon, 31 Dec 2007 13:12:45 -0500
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311312.46450.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since asm-x86/byteorder.h is exported to userspace, use __asm__ rather than
asm in its code.

Signed-Off-By: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-x86/byteorder.h b/include/asm-x86/byteorder.h
index 1f2d6d5..fe2f2e5 100644
--- a/include/asm-x86/byteorder.h
+++ b/include/asm-x86/byteorder.h
@@ -30,13 +30,13 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 val)
 	} v;
 	v.u = val;
 #ifdef CONFIG_X86_BSWAP
-	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
+	__asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 #else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
-	asm("xchgl %0,%1" : "=r" (v.s.a), "=r" (v.s.b) : "0" (v.s.a), "1" (v.s.b));
+	__asm__("xchgl %0,%1" : "=r" (v.s.a), "=r" (v.s.b) : "0" (v.s.a), "1" (v.s.b));
 #endif
 	return v.u;
 }
