Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYKJGMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYKJGMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYKJGM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:12:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:36622 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYKJGM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Eb6nti4/WFvwv30is60aohTcWUgKnrvXkwop00XxJRi89VsVUxyV1tXX3mUGVyKI4p
         sRCCS6+PWhydyThz6CtXF9SU4OCxYRI21Gf0VRySoRM+ypCgDQw+psxoM6FDy5YxBLGA
         4m6FA5NloEnyKDTQismqB5UwdwKixbjP5/MFo=
Subject: [RFC-PATCH] x86: really use __builtin_memcmp on x86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 22:12:23 -0800
Message-Id: <1226297544.5478.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: prevent generic code from overriding __builtin_memcmp

lib/string.c was using a generic implementation of memcmp
because __HAVE_ARCH_MEMCMP was not defined and it was then doing
#undef memcmp and defining a generic version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/include/asm/string_32.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index c86f452..b671baf 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -195,6 +195,7 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t n);
 
+#define __HAVE_ARCH_MEMCMP
 #define memcmp __builtin_memcmp
 
 #define __HAVE_ARCH_MEMCHR
-- 
1.6.0.3.866.gc189b



