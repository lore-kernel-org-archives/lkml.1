Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZJ3PSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZJ3PSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 11:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbZJ3PSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 11:18:54 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:38569 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbZJ3PSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 11:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JDThxn3SI+nexHk8+TCnUQWGVW6XuDPSanHgM3lMA0c9RZj/zWDUUkvVM4twIDFzQJ
         UcSwYusP+xq8w9Np69u7Til2W0E1qUTQWGF/p0YLJzrGyFewsoYzAzS/oqNfNX0fYXxp
         LfDq+LSbxzTJ9WW3MrHeoeOqUHguIwiFEqG7c=
MIME-Version: 1.0
Date: Fri, 30 Oct 2009 21:18:57 +0600
Message-ID: <b9df5fa10910300818u4b104a50if01f32c26be580d8@mail.gmail.com>
Subject: [PATCH] x86, tsc: Remove checking cpu_has_tsc when CONFIG_X86_TSC=n.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When CONFIG_X86_TSC=n, we do not need to check cpu_has_tsc, we can
simply return with 0. Moreover cpu_has_tsc indicates whether cpu
tsc feature on or not, so it doesn't matter when CONFIG_X86_TSC=n.
Am I right? Or I'm missing anything?

----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/include/asm/tsc.h	2009-10-17 13:12:59.000000000 +0600
+++ rakib/arch/x86/include/asm/tsc.h	2009-10-30 21:55:29.000000000 +0600
@@ -24,8 +24,7 @@ static inline cycles_t get_cycles(void)
 	unsigned long long ret = 0;

 #ifndef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		return 0;
+	return 0;
 #endif
 	rdtscll(ret);

@@ -39,8 +38,7 @@ static __always_inline cycles_t vget_cyc
 	 * access boot_cpu_data (which is not VDSO-safe):
 	 */
 #ifndef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		return 0;
+	return 0;
 #endif
 	return (cycles_t)__native_read_tsc();
 }
