Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZCDAIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZCDAIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZCDAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:07:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:51753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754742AbZCDAHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:07:55 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+CjcQXFwSCNVVBsvwiQG9kBLuPy9E+lnzRVMrO8c
	CDsaNBN4S22F8k
Date: Wed, 4 Mar 2009 01:07:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Linux 2.6.29-rc6 bombs while compiling a kernel for a
 linkstation/kurobox
In-Reply-To: <20090302094303.GA29819@ime.usp.br>
Message-ID: <Pine.LNX.4.64.0903040103440.5059@axis700.grange>
References: <20090302094303.GA29819@ime.usp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, Rogério Brito wrote:

> Hi there.
> 
> I tried to compile a new kernel for my (powerpc) Kurobox HD (an embedded
> system that has a Freescale processor), but it seems that the
> compilation fails, with both my usual config file and with the shipped
> linkstation_defconfig file.
> 
> I get the following error during compilation (actually a
> cross-compilation):
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> arch/powerpc/platforms/built-in.o: In function `linkstation_setup_arch':
> linkstation.c:(.init.text+0x218): undefined reference to `physmap_set_partitions'
> drivers/built-in.o:(__ksymtab+0x9f8): undefined reference to `physmap_set_partitions'
> make: *** [.tmp_vmlinux1] Error 1
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Yes, linkstation and storcenter have to migrate to the "physmap-flash" 
platform driver. For now you can define in your .config

CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0xffc00000
CONFIG_MTD_PHYSMAP_LEN=0x400000
CONFIG_MTD_PHYSMAP_BANKWIDTH=1

(I hope the numbers are correct, just found them in my local tree, don't 
remember any more what exactly they configure, please, double-check.) And 
yes, it must be fixed in the mainline. I'll see if I find time for this, 
maybe tomorrow (actually, already today.)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
