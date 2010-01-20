Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997Ab0ATQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab0ATQKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122Ab0ATQKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:10:14 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48711 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab0ATQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:10:13 -0500
Message-Id: <1264003812.20542.1355658217@webmail.messagingengine.com>
X-Sasl-Enc: BuPKQ8ueY2/LGQc96bq7BnWYU0seQQuDMQ7kix6Av13r 1264003812
From: myuboot@fastmail.fm
To: "David Daney" <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <4B564496.3090509@caviumnetworks.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
 <1263930694.9779.1355491925@webmail.messagingengine.com>
 <4B564496.3090509@caviumnetworks.com>
Subject: Re: loadable kernel module link failure -  endianness incompatible with
 that of the selected emulation
Date: Wed, 20 Jan 2010 10:10:12 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jan 2010 15:47 -0800, "David Daney"
<ddaney@caviumnetworks.com> wrote:
> myuboot@fastmail.fm wrote:
> > I got a link error when compiling 2 loadable kernel modules -
> > "endianness incompatible with that of the selected emulation". 
> > 
> > But both kernel and the kernel modules of error are in big endian. I
> > don't know what I should check or fix. Any suggestions? I checked the
> > endianess of the kernel by checking the elf header of vmlinux file, is
> > that the right way to do it?
> > 
> > Below are the error info and the readelf output, showing both the kernel
> > and a kernel module are in big endian.
> > Thanks for your help. Andrew
> > 
> > 1) error log 
> > make -C /home/root123/sources/kernel/linux
> > CROSS_COMPILE=""/home/root123/sources/gcc3.4.3-be"/bin/mips-linux-"
> > M=/home/root123/sources/sdk/platform/src/linux/mxp/src modules    
> > 
> >   LD [M]  /home/root123/sources/sdk/platform/src/linux/mxp/src/mxpmod.o
> > /home/root123/sources/gcc3.4.3-be/bin/mips-linux-ld:
> > /home/root123/sources/sdk/platform/src/linux/mxp/src/mmxpcore.o:
> > compiled for a big endian system and target is little endian
> > /home/root123/sources/gcc3.4.3-be/bin/mips-linux-ld:
> > /home/root123/sources/sdk/platform/src/linux/mxp/src/mmxpcore.o:
> > endianness incompatible with that of the selected emulation
> > /home/root123/sources/gcc3.4.3-be/bin/mips-linux-ld: failed to merge
> > target specific data of file
> > /home/root123/sources/sdk/platform/src/linux/mxp/src/mmxpcore.o
> > make[13]: ***
> > [/home/root123/sources/sdk/platform/src/linux/mxp/src/mxpmod.o] Error 1
> > 
> 
> Looks like a toolchain bug/configuration-problem.  Hard to tell though 
> as you didn't pass 'V=1' on the make invocation line.
> 
> David Daney
With the V=1 option suggested, I found the culprit is this "-m
elf32ltsmip". It is working now.

Thanks. Andrew
