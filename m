Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXJWSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXJWSBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXJWSBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:01:17 -0400
Received: from xenotime.net ([66.160.160.81]:43449 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752001AbXJWSBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:01:17 -0400
Date: Tue, 23 Oct 2007 11:01:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [ARM] : Section mismatch : reference to......
Message-Id: <20071023110113.a98c36a8.rdunlap@xenotime.net>
In-Reply-To: <20071023195207.e52e22e5.Kristoffer.ericson@gmail.com>
References: <20071023195207.e52e22e5.Kristoffer.ericson@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 19:52:07 -0700 Kristoffer Ericson wrote:

> Best way to handle this?
> 
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
>   KSYM    .tmp_kallsyms1.S
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x9afc): Section mismatch: reference to .init.text:sa1110_mb_enable (between 'sa1111_probe' and 'sa1111_remove')
> WARNING: vmlinux.o(.text+0x13b1ac): Section mismatch: reference to .init.text:pcmcia_jornada720_init (between 'pcmcia_probe' and 'pcmcia_remove')
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
>   OBJCOPY arch/arm/boot/Image
>   Kernel: arch/arm/boot/Image is ready
>   AS      arch/arm/boot/compressed/head.o
>   GZIP    arch/arm/boot/compressed/piggy.gz
>   AS      arch/arm/boot/compressed/piggy.o
>   CC      arch/arm/boot/compressed/misc.o
>   AS      arch/arm/boot/compressed/head-sa1100.o
>   LD      arch/arm/boot/compressed/vmlinux
>   OBJCOPY arch/arm/boot/zImage
>   Kernel: arch/arm/boot/zImage is ready
> -

Missing kernel version and .config file.

In drivers/pcmcia/sa1100_jornada.c, change

int __init pcmcia_jornada720_init(struct device *dev)

to

int __devinit pcmcia_jornada720_init(struct device *dev)

may help.  Please test that.

I can't find sa1110_mb_enable().

---
~Randy
