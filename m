Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbXJWSd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbXJWSd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXJWSdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:33:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:23279 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXJWSdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=oVheJ0aqNQJu1dW5rr4RFNnbLhRAYUuY8q8CgPZca0bEMKrroULZvg7E8uW00TyZXs3i0ZCDAfisWthBYCzjLOEW5DxPvqpOoFr8djA3XpcHtoUPS4J1X0emwcYQXfgh1Vkzl7QtR1LdxuIK+MhmD/HqXS3djbPHoYWUIU76FOI=
Date: Tue, 23 Oct 2007 20:33:11 -0700
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [ARM] : Section mismatch : reference to......
Message-Id: <20071023203311.ddf75b88.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071023113001.d87b762c.rdunlap@xenotime.net>
References: <20071023195207.e52e22e5.Kristoffer.ericson@gmail.com>
	<20071023110113.a98c36a8.rdunlap@xenotime.net>
	<20071023200906.42db6a45.Kristoffer.ericson@gmail.com>
	<20071023111506.31b30043.rdunlap@xenotime.net>
	<20071023202020.6db71a9b.Kristoffer.ericson@gmail.com>
	<20071023113001.d87b762c.rdunlap@xenotime.net>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 11:30:01 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Tue, 23 Oct 2007 20:20:20 -0700 Kristoffer Ericson wrote:
> 
> > On Tue, 23 Oct 2007 11:15:06 -0700
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > On Tue, 23 Oct 2007 20:09:06 -0700 Kristoffer Ericson wrote:
> > > 
> > > > On Tue, 23 Oct 2007 11:01:13 -0700
> > > > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > > > 
> > > > > On Tue, 23 Oct 2007 19:52:07 -0700 Kristoffer Ericson wrote:
> > > > > 
> > > > > > Best way to handle this?
> > > > > > 
> > > > > > 
> > > > > >   LD      init/built-in.o
> > > > > >   LD      .tmp_vmlinux1
> > > > > >   KSYM    .tmp_kallsyms1.S
> > > > > >   AS      .tmp_kallsyms1.o
> > > > > >   LD      .tmp_vmlinux2
> > > > > >   KSYM    .tmp_kallsyms2.S
> > > > > >   AS      .tmp_kallsyms2.o
> > > > > >   LD      vmlinux.o
> > > > > >   MODPOST vmlinux.o
> > > > > > WARNING: vmlinux.o(.text+0x9afc): Section mismatch: reference to .init.text:sa1110_mb_enable (between 'sa1111_probe' and 'sa1111_remove')
> > > > > > WARNING: vmlinux.o(.text+0x13b1ac): Section mismatch: reference to .init.text:pcmcia_jornada720_init (between 'pcmcia_probe' and 'pcmcia_remove')
> > > > > >   LD      vmlinux
> > > > > >   SYSMAP  System.map
> > > > > >   SYSMAP  .tmp_System.map
> > > > > >   OBJCOPY arch/arm/boot/Image
> > > > > >   Kernel: arch/arm/boot/Image is ready
> > > > > >   AS      arch/arm/boot/compressed/head.o
> > > > > >   GZIP    arch/arm/boot/compressed/piggy.gz
> > > > > >   AS      arch/arm/boot/compressed/piggy.o
> > > > > >   CC      arch/arm/boot/compressed/misc.o
> > > > > >   AS      arch/arm/boot/compressed/head-sa1100.o
> > > > > >   LD      arch/arm/boot/compressed/vmlinux
> > > > > >   OBJCOPY arch/arm/boot/zImage
> > > > > >   Kernel: arch/arm/boot/zImage is ready
> > > > > > -
> > > > > 
> > > > > Missing kernel version and .config file.
> > > > Ah, true. Im using latest git (linux-2.6.git) with proper config. This error has been there for quite some time, just decided it was time to fix it. Im not fully familiar with the section errors, so thought it better to ask.
> > > > 
> > > > > 
> > > > > In drivers/pcmcia/sa1100_jornada.c, change
> > > > > 
> > > > > int __init pcmcia_jornada720_init(struct device *dev)
> > > > > 
> > > > > to
> > > > > 
> > > > > int __devinit pcmcia_jornada720_init(struct device *dev)
> > > > > 
> > > > > may help.  Please test that.
> > > > Seems to work fine, big thanks. 
> > > > > 
> > > > > I can't find sa1110_mb_enable().
> > > > Found it inside /arch/arm/mach-sa1100/generic.c, proper way to set it as __devinit?
> > > 
> > > Probably, at least it's worth trying.
> > Seems to have worked fine. Could anyone explain why?.. Or I can google it I guess.
> > Anyhow big thanx Randy
> 
> You have CONFIG_HOTPLUG=y in your .config file?
> 
> If yes, see what that does to include/linux/init.h:
> 
> #ifdef CONFIG_HOTPLUG
> #define __devinit
> #define __devinitdata
> #define __devexit
> #define __devexitdata
> #else
> #define __devinit __init
> #define __devinitdata __initdata
> #define __devexit __exit
> #define __devexitdata __exitdata
> #endif
> 
> 
> so those __devinit functions are not discarded when CONFIG_HOTPLUG=y,
> but they are discarded when CONFIG_HOTPLUG=n.
I got CONFIG_HOTPLUG = y, so should be alright then.

> 
> 
> ---
> ~Randy
