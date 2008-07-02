Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbYGBHQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbYGBHQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbYGBHQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:16:39 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:50828 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386AbYGBHQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:16:38 -0400
Message-ID: <486B2A99.5040102@cetrtapot.si>
Date: Wed, 02 Jul 2008 09:13:29 +0200
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH linux-next 1/1] cris: look for linker scripts in srctree
 not in objtree
References: <4849213A.4080001@cetrtapot.si> <486A3A6C.4000506@cetrtapot.si> <20080701160240.GD3921@axis.com>
In-Reply-To: <20080701160240.GD3921@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Nilsson wrote:
> Hi!
> 
> On Tue, Jul 01, 2008 at 04:08:44PM +0200, Hinko Kocevar wrote:
>> When building kernel with O= linker looks for linker scripts in output tree, while they are located in source tree.
>>
>> Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
> 
> I think this would be cleaner:
> 
> diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
> --- a/arch/cris/arch-v10/boot/compressed/Makefile
> +++ b/arch/cris/arch-v10/boot/compressed/Makefile
> @@ -4,7 +4,7 @@
>  
>  asflags-y += $(LINUXINCLUDE)
>  ccflags-y += -O2 $(LINUXINCLUDE)
> -ldflags-y += -T $(obj)/decompress.ld
> +ldflags-y += -T $(srctree)/$(src)/decompress.ld
>  OBJECTS = $(obj)/head.o $(obj)/misc.o
>  OBJCOPYFLAGS = -O binary --remove-section=.bss
>  
> diff --git a/arch/cris/arch-v10/boot/rescue/Makefile b/arch/cris/arch-v10/boot/rescue/Makefile
> --- a/arch/cris/arch-v10/boot/rescue/Makefile
> +++ b/arch/cris/arch-v10/boot/rescue/Makefile
> @@ -4,7 +4,7 @@
>  
>  ccflags-y += -O2 $(LINUXINCLUDE)
>  asflags-y += $(LINUXINCLUDE)
> -ldflags-y += -T $(obj)/rescue.ld
> +ldflags-y += -T $(srctree)/$(src)/rescue.ld
>  OBJCOPYFLAGS = -O binary --remove-section=.bss
>  obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o
>  OBJECT := $(obj)/head.o
> 
> 

It certainly is.

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

