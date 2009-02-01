Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZBARbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZBARbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBARbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:31:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:43370 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZBARbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:31:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lNSxi1Y0BLvOZBKEnNpi1HRsb3MEaveeAQSo0fI7pfiP7dNvfBD0RV5kZoY1N3Zirn
         wmgtoMSfZWhNOxEBm92uK1y4+lvTaOPySbeja51dAzJwear3c/04BW4yIomE3Pbi0kIQ
         +Ni0nNzZJbxpo7UHby8HHZuNLX6Pkbo4m+PQM=
MIME-Version: 1.0
In-Reply-To: <20090201172018.GB21913@n2100.arm.linux.org.uk>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <20090131164410.GA11189@elte.hu>
	 <1233469811.5846.14.camel@localhost.localdomain>
	 <20090201103936.GA30157@elte.hu> <20090201164915.GA29264@elte.hu>
	 <20090201172018.GB21913@n2100.arm.linux.org.uk>
Date: Sun, 1 Feb 2009 23:01:41 +0530
Message-ID: <3f9a31f40902010931p24cbfabekec442078914e3d6e@mail.gmail.com>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 1, 2009 at 10:50 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Feb 01, 2009 at 05:49:15PM +0100, Ingo Molnar wrote:
>>
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>> > > These patches fixes 41 headers_check warnings as shown in first email.
>> >
>> > Pulled into tip/core/header-fixes, thanks Jaswinder!
>>
>> These are the remaining ones on x86:
>>
>>      17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
>>      12 /dev/shm/tip/usr/include/linux/soundcard.h
>>       6 /dev/shm/tip/usr/include/asm/setup.h
>>       3 /dev/shm/tip/usr/include/linux/nubus.h
>>       2 /dev/shm/tip/usr/include/linux/in6.h
>>       1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
>>       1 /dev/shm/tip/usr/include/linux/socket.h
>>       1 /dev/shm/tip/usr/include/linux/coda_psdev.h
>>       1 /dev/shm/tip/usr/include/asm/prctl.h
>>
>> They are all of the "extern's make no sense in userspace" type. What was the
>> verdict, are they worth touching, or should we turn off this warning in
>> 'make headers_check'?
>
> Ah, not a case of new-cc's added.  A case of the rare event of non-spam
> eminating from hera.kernel.org falling foul of my manual local blacklist.
>
> I'd appreciate it if someone could point me at the original patches
> being discussed.

I am sorry, if you did not received the email but you was in CC list:

Ingo Molnar <mingo@elte.hu>,
Linus Torvalds <torvalds@linux-foundation.org>,
Sam Ravnborg <sam@ravnborg.org>,
Andrew Morton <akpm@linux-foundation.org>,
Russell King - ARM Linux <linux@arm.linux.org.uk>,
hskinnemoen@atmel.com,
cooloney@kernel.org,
tony.luck@intel.com,
ralf@linux-mips.org,
dhowells@redhat.com,
matthew@wil.cx,
chris@zankel.net,
LKML <linux-kernel@vger.kernel.org>

Arms bits are :

These are clean patches, I did not included anything which leads to any
confusion or conflicts. I hope maintainers do not mind if these patches
go to mainstream via Ingo's -tip along with other headers_check fixes.

Jaswinder Singh Rajput (3):
     headers_check fix: arm, a.out.h
     headers_check fix: arm, setup.h
     headers_check fix: arm, swab.h

diff --git a/arch/arm/include/asm/a.out.h b/arch/arm/include/asm/a.out.h
index 79489fd..083894b 100644
--- a/arch/arm/include/asm/a.out.h
+++ b/arch/arm/include/asm/a.out.h
@@ -2,7 +2,7 @@
 #define __ARM_A_OUT_H__

 #include <linux/personality.h>
-#include <asm/types.h>
+#include <linux/types.h>

 struct exec
 {
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index f2cd18a..ee1304f 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -14,7 +14,7 @@
 #ifndef __ASMARM_SETUP_H
 #define __ASMARM_SETUP_H

-#include <asm/types.h>
+#include <linux/types.h>

 #define COMMAND_LINE_SIZE 1024

diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
index 27a689b..ca2bf2f 100644
--- a/arch/arm/include/asm/swab.h
+++ b/arch/arm/include/asm/swab.h
@@ -16,7 +16,7 @@
 #define __ASM_ARM_SWAB_H

 #include <linux/compiler.h>
-#include <asm/types.h>
+#include <linux/types.h>

 #if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
 #  define __SWAB_64_THRU_32__

Thanks,
--
JSR
