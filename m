Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYGAQCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYGAQCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYGAQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:02:46 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:45490 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYGAQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:02:46 -0400
Date: Tue, 1 Jul 2008 18:02:41 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH linux-next 1/1] cris: look for linker scripts in srctree not in objtree
Message-ID: <20080701160240.GD3921@axis.com>
References: <4849213A.4080001@cetrtapot.si> <486A3A6C.4000506@cetrtapot.si>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A3A6C.4000506@cetrtapot.si>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Jul 01, 2008 at 04:08:44PM +0200, Hinko Kocevar wrote:
> When building kernel with O= linker looks for linker scripts in output tree, while they are located in source tree.
>
> Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

I think this would be cleaner:

diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
--- a/arch/cris/arch-v10/boot/compressed/Makefile
+++ b/arch/cris/arch-v10/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 
 asflags-y += $(LINUXINCLUDE)
 ccflags-y += -O2 $(LINUXINCLUDE)
-ldflags-y += -T $(obj)/decompress.ld
+ldflags-y += -T $(srctree)/$(src)/decompress.ld
 OBJECTS = $(obj)/head.o $(obj)/misc.o
 OBJCOPYFLAGS = -O binary --remove-section=.bss
 
diff --git a/arch/cris/arch-v10/boot/rescue/Makefile b/arch/cris/arch-v10/boot/rescue/Makefile
--- a/arch/cris/arch-v10/boot/rescue/Makefile
+++ b/arch/cris/arch-v10/boot/rescue/Makefile
@@ -4,7 +4,7 @@
 
 ccflags-y += -O2 $(LINUXINCLUDE)
 asflags-y += $(LINUXINCLUDE)
-ldflags-y += -T $(obj)/rescue.ld
+ldflags-y += -T $(srctree)/$(src)/rescue.ld
 OBJCOPYFLAGS = -O binary --remove-section=.bss
 obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o
 OBJECT := $(obj)/head.o


> ---
> diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
> index 9ec5f87..cc6527d 100644
> --- a/arch/cris/arch-v10/boot/compressed/Makefile
> +++ b/arch/cris/arch-v10/boot/compressed/Makefile
> @@ -4,7 +4,7 @@
>  
>  asflags-y += $(LINUXINCLUDE)
>  ccflags-y += -O2 $(LINUXINCLUDE)
> -ldflags-y += -T $(obj)/decompress.ld
> +ldflags-y += -T $(srctree)/arch/$(ARCH)/boot/compressed/decompress.ld

>  OBJECTS = $(obj)/head.o $(obj)/misc.o
>  OBJCOPYFLAGS = -O binary --remove-section=.bss
>  
> diff --git a/arch/cris/arch-v10/boot/rescue/Makefile b/arch/cris/arch-v10/boot/rescue/Makefile
> index bea8b9c..476007d 100644
> --- a/arch/cris/arch-v10/boot/rescue/Makefile
> +++ b/arch/cris/arch-v10/boot/rescue/Makefile
> @@ -4,7 +4,7 @@
>  
>  ccflags-y += -O2 $(LINUXINCLUDE)
>  asflags-y += $(LINUXINCLUDE)
> -ldflags-y += -T $(obj)/rescue.ld
> +ldflags-y += -T $(srctree)/arch/$(ARCH)/boot/rescue/rescue.ld
>  OBJCOPYFLAGS = -O binary --remove-section=.bss
>  obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o
>  OBJECT := $(obj)/head.o

Thanks!

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
