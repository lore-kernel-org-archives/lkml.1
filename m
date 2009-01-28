Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZA1V6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZA1V6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZA1V6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:58:10 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:43824 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZA1V6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J1qvZ1i59qXbrackGkerstvb7ke1WVM2sk2OqbbcD+MSKIVWnNNpOStVlkMVQmpB4w
         uCi2UrpM4lFxIEf/a0tClrBjN59Vu+PoLZxj5zQASOofXNK+sNBeXAollBcoiqu5Fj1Q
         M5QssmJrOpbO9UmX9PjLcSr2dZpX7bLch1/ZM=
Subject: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4980CD51.70601@zytor.com>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <1233106614.3256.6.camel@localhost.localdomain>
	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>
	 <1233170532.6717.49.camel@brick>
	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
	 <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 13:58:04 -0800
Message-Id: <1233179884.6717.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ifdef __i486__ to ensure the BSWAP instruction is available
on 32-bit x86.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
HPA,

I'm afraid my knowledge of gcc compiler flags for various models is
lacking, I used i486 as suggested, just wanted to make sure I understood
you corectly.

 arch/x86/include/asm/swab.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 306d417..9af180c 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -7,7 +7,7 @@
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 #ifdef __i386__
-# ifdef CONFIG_X86_BSWAP
+# ifdef __i486__
 	asm("bswap %0" : "=r" (val) : "0" (val));
 # else
 	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
@@ -37,7 +37,7 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-# ifdef CONFIG_X86_BSWAP
+# ifdef __i486__
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-- 
1.6.1.401.gf39d5



