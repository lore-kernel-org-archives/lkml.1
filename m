Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbXJWSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbXJWSJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJWSJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:09:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:28071 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbXJWSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=maoMnLZ/b/OPDrMHWeU9V6QTO77FjuMKfmgZRrecIfCgnveV797TgyXyNHtnjcFtqGuZWDwJ5H5gruGSpv9Dy7qjks0w+numN6TPj7jEn+I5OOS7uEl4W+4phMGw5MiIPgIs0v0Lyj3q++5hyIa7SIf/FCeF+0IkCa2YbcCev2Y=
Date: Tue, 23 Oct 2007 20:09:06 -0700
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [ARM] : Section mismatch : reference to......
Message-Id: <20071023200906.42db6a45.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071023110113.a98c36a8.rdunlap@xenotime.net>
References: <20071023195207.e52e22e5.Kristoffer.ericson@gmail.com>
	<20071023110113.a98c36a8.rdunlap@xenotime.net>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 11:01:13 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Tue, 23 Oct 2007 19:52:07 -0700 Kristoffer Ericson wrote:
> 
> > Best way to handle this?
> > 
> > 
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> >   KSYM    .tmp_kallsyms1.S
> >   AS      .tmp_kallsyms1.o
> >   LD      .tmp_vmlinux2
> >   KSYM    .tmp_kallsyms2.S
> >   AS      .tmp_kallsyms2.o
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> > WARNING: vmlinux.o(.text+0x9afc): Section mismatch: reference to .init.text:sa1110_mb_enable (between 'sa1111_probe' and 'sa1111_remove')
> > WARNING: vmlinux.o(.text+0x13b1ac): Section mismatch: reference to .init.text:pcmcia_jornada720_init (between 'pcmcia_probe' and 'pcmcia_remove')
> >   LD      vmlinux
> >   SYSMAP  System.map
> >   SYSMAP  .tmp_System.map
> >   OBJCOPY arch/arm/boot/Image
> >   Kernel: arch/arm/boot/Image is ready
> >   AS      arch/arm/boot/compressed/head.o
> >   GZIP    arch/arm/boot/compressed/piggy.gz
> >   AS      arch/arm/boot/compressed/piggy.o
> >   CC      arch/arm/boot/compressed/misc.o
> >   AS      arch/arm/boot/compressed/head-sa1100.o
> >   LD      arch/arm/boot/compressed/vmlinux
> >   OBJCOPY arch/arm/boot/zImage
> >   Kernel: arch/arm/boot/zImage is ready
> > -
> 
> Missing kernel version and .config file.
Ah, true. Im using latest git (linux-2.6.git) with proper config. This error has been there for quite some time, just decided it was time to fix it. Im not fully familiar with the section errors, so thought it better to ask.

> 
> In drivers/pcmcia/sa1100_jornada.c, change
> 
> int __init pcmcia_jornada720_init(struct device *dev)
> 
> to
> 
> int __devinit pcmcia_jornada720_init(struct device *dev)
> 
> may help.  Please test that.
Seems to work fine, big thanks. 
> 
> I can't find sa1110_mb_enable().
Found it inside /arch/arm/mach-sa1100/generic.c, proper way to set it as __devinit?
> 
> ---
> ~Randy
