Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXE1LFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXE1LFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXE1LFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:05:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:9070 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXE1LFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c4V34F5hqykLxA0QDfTEo+j/RHVMJHPuHxZSJ1rhWuRkGzOYqg3gCyE1sctjwZ6FxryYonfSlf6HZ4OLeehj2qvVtZoSDfgV3YqGTtRkWVmkIrVOAKBd9FrHhDtstzq+xySqMgm6PncztZgzfLovZ/MxZI7BHKskw2Wx+JdQmAI=
Message-ID: <9b9ffe290705280405m5086f2dbldea5961ed2b057ca@mail.gmail.com>
Date: Mon, 28 May 2007 19:05:43 +0800
From: "=?UTF-8?B?5LiB5LiB?=" <sns2002@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: An error of compile kernel2.6.22-rc3 for ARM CPU s3c2440
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,All.

I compiled new kernel2.6.22-rc3 for my s3c2440 platform yesterday,
I got follow error message from gcc-compiler.

>CC      arch/arm/plat-s3c24xx/devs.o
>linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:410:
error:'S3C2443_PA_HSMMC' undeclared here (not in a function)
>linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:411:
error:'S3C2443_SZ_HSMMC' undeclared here (not in a function)

I found the reason of the error is the two marco  wasn't add into the
file "arch-s3c2410/map.h",so I make a patch file for the problem.

>>------------------------------------------------------
fix_miss_marco_for_s3c2443.patch
>>------------------------------------------------------
diff -Nurp linux-2.6.22-rc3-org/include/asm-arm/arch-s3c2410/map.h
linux-2.6.22-rc3/include/asm-arm/arch-s3c2410/map.h
--- linux-2.6.22-rc3-org/include/asm-arm/arch-s3c2410/map.h     2007-04-26
11:08:32.000000000 +0800
+++ linux-2.6.22-rc3/include/asm-arm/arch-s3c2410/map.h 2007-05-28
18:38:54.000000000 +0800
@@ -153,6 +153,10 @@
 #define S3C2440_PA_AC97           (0x5B000000)
 #define S3C2440_SZ_AC97           SZ_1M

+/* High-speed MMC/SD */
+#define S3C2443_PA_HSMMC          (0x4A800000)
+#define S3C2443_SZ_HSMMC          0xFF
+
 /* ISA style IO, for each machine to sort out mappings for, if it
 * implements it. We reserve two 16M regions for ISA.
 */


-------
Ding Yi
sns2002@gmail.com
-------
