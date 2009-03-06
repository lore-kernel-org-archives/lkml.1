Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZCFQhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZCFQhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCFQhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:37:08 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:36457 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZCFQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:37:06 -0500
Message-ID: <49B1517C.7000809@oracle.com>
Date: Fri, 06 Mar 2009 08:38:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: phil@hannent.co.uk, mwilder@cs.nmsu.edu, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: [PATCH] Re: build issue #591 for v2.6.29-rc7-3-g559595a :drivers/staging/mimio/mimio.ko
References: <200903060928.24462.toralf.foerster@gmx.de>
In-Reply-To: <200903060928.24462.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49B1511B.0008:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   CC      arch/x86/boot/video-bios.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   HOSTCC  arch/x86/boot/tools/build
>   BUILD   arch/x86/boot/bzImage
> Root device is (3, 8)
> Setup is 22056 bytes (padded to 22528 bytes).
> System is 3078 kB
> CRC b46a0cef
> Kernel: arch/x86/boot/bzImage is ready  (#6)
>   Building modules, stage 2.
>   MODPOST 327 modules
> ERROR: "input_register_device" [drivers/staging/mimio/mimio.ko] undefined!
> ERROR: "input_allocate_device" [drivers/staging/mimio/mimio.ko] undefined!
> ERROR: "input_event" [drivers/staging/mimio/mimio.ko] undefined!
> ERROR: "input_close_device" [drivers/staging/mimio/mimio.ko] undefined!
> ERROR: "input_free_device" [drivers/staging/mimio/mimio.ko] undefined!
> ERROR: "input_unregister_device" [drivers/staging/mimio/mimio.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> The build was made with :
> $>make randconfig; make clean; make
> 
> Here's the config:

[snip]

I posted a patch for this on Feb. 20.
Where is it, Greg?  (yes, you were cc-ed on it)

bah, here it is again.






From: Randy Dunlap <randy.dunlap@oracle.com>

mimio driver uses input_* functions so it needs to depend on INPUT.

mimio.c:(.text+0x2526c9): undefined reference to `input_unregister_device'
mimio.c:(.text+0x2526da): undefined reference to `input_close_device'
mimio.c:(.text+0x252725): undefined reference to `input_free_device'
mimio.c:(.text+0x2528f1): undefined reference to `input_event'
mimio.c:(.text+0x252904): undefined reference to `input_event'
mimio.c:(.text+0x252921): undefined reference to `input_event'
mimio.c:(.text+0x252b3e): undefined reference to `input_event'
mimio.c:(.text+0x252b51): undefined reference to `input_event'
drivers/built-in.o:mimio.c:(.text+0x252bbd): more undefined references to `input_event' follow
mimio.c:(.text+0x252e42): undefined reference to `input_allocate_device'
mimio.c:(.text+0x2530ef): undefined reference to `input_register_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: mwilder@cs.nmsu.edu
---
 drivers/staging/mimio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090220.orig/drivers/staging/mimio/Kconfig
+++ linux-next-20090220/drivers/staging/mimio/Kconfig
@@ -1,6 +1,6 @@
 config INPUT_MIMIO
 	tristate "Mimio Xi interactive whiteboard support"
-	depends on USB
+	depends on USB && INPUT
 	default N
 	help
 	  Say Y here if you want to use a Mimio Xi interactive
