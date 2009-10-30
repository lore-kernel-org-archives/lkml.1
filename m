Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZJ3LLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZJ3LLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZJ3LLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:11:45 -0400
Received: from aa002msb.fastweb.it ([85.18.95.81]:45921 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZJ3LLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:11:44 -0400
Message-ID: <4AEAC9D8.9000304@evidence.eu.com>
Date: Fri, 30 Oct 2009 12:11:20 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
       akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][RE-SUBMIT] Default setting of the ARM_UNWIND option
References: <4AD73DA4.4050006@evidence.eu.com>	 <1255620333.10164.77.camel@pc1117.cambridge.arm.com>	 <4AE55D83.7080608@evidence.eu.com>	 <1256555452.5282.21.camel@pc1117.cambridge.arm.com>	 <4AE82D17.6040900@evidence.eu.com> <1256741902.27121.29.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1256741902.27121.29.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/mixed;
 boundary="------------080005000802070703050006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080005000802070703050006
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

    I modified the patch according to your suggestions.

> 
> You can just send it to Russell's patch system once there are no more
> comments on it.

Done. I'm attaching the latest version here too.

Many thanks,

            Claudio

--------------080005000802070703050006
Content-Type: text/x-patch;
 name="0001-ARM-unwind-is-known-to-compile-only-with-EABI-and-no.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-ARM-unwind-is-known-to-compile-only-with-EABI-and-no.pa";
 filename*1="tch"

From: Claudio Scordino <claudio@evidence.eu.com>
Date: Fri, 30 Oct 2009 11:46:00 +0100
Subject: [PATCH 1/1] ARM unwind is known to compile only with EABI and not-buggy compilers.

ARM unwind is known to compile only with EABI and not-buggy compilers.
The problem is not the unwinding information but the -fno-frame-pointer option added as a result of !CONFIG_FRAME_POINTER.
Now we check the compiler and raise a #warning in case of wrong compiler.


Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 arch/arm/kernel/unwind.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 39baf11..786ac2b 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -26,6 +26,15 @@
  * http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
  */
 
+#if !defined (__ARM_EABI__)
+#warning Your compiler does not have EABI support.
+#warning    ARM unwind is known to compile only with EABI compilers.
+#warning    Change compiler or disable ARM_UNWIND option.
+#elif (__GNUC__ == 4 && __GNUC_MINOR__ <= 2)
+#warning Your compiler is too buggy; it is known to not compile ARM unwind support.
+#warning    Change compiler or disable ARM_UNWIND option.
+#endif
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
-- 
1.6.0.4


--------------080005000802070703050006--
