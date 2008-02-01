Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbYBAGPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbYBAGPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYBAGPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:15:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:26362 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYBAGPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:15:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VDtxBTiixKFwFy6yI/BurmbY5rYJ4LJVP80jLRCcqi7ej9n3vOffdpDJUoHzPiG2+RmEhMEW5LL6FZai53Gp27Srmxem9ytRwe1GPd8K8RimHf98tUlzUjuil42Oi6dcvm2KEKMvz45TiorlJrKaUbVBMMdMTgmlwZ0mqB+QAnA=
Subject: [PATCH] x86: sparse errors from string_32.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 22:15:16 -0800
Message-Id: <1201846516.23523.87.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm/string_32.h:216:26: warning: cast truncates bits from constant value (cccccccc becomes cc)
include/asm/string_32.h:219:27: warning: cast truncates bits from constant value (cccccccc becomes cccc)
include/asm/string_32.h:222:27: warning: cast truncates bits from constant value (cccccccc becomes cccc)
include/asm/string_32.h:223:30: warning: cast truncates bits from constant value (cccccccc becomes cc)

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this shows up over and over again during the build, this
doesn't change anything as they are known compile-time constants
at this point, the and-ing just makes the truncation explicit.

If you disagree with this method, no worries.

 include/asm-x86/string_32.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index 55bfa30..c5d13a8 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -213,14 +213,14 @@ static __always_inline void * __constant_c_and_count_memset(void * s, unsigned l
 		case 0:
 			return s;
 		case 1:
-			*(unsigned char *)s = pattern;
+			*(unsigned char *)s = pattern & 0xff;
 			return s;
 		case 2:
-			*(unsigned short *)s = pattern;
+			*(unsigned short *)s = pattern & 0xffff;
 			return s;
 		case 3:
-			*(unsigned short *)s = pattern;
-			*(2+(unsigned char *)s) = pattern;
+			*(unsigned short *)s = pattern & 0xffff;
+			*(2+(unsigned char *)s) = pattern & 0xff;
 			return s;
 		case 4:
 			*(unsigned long *)s = pattern;
-- 
1.5.4.rc4.1142.gf5a97



