Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbXEPRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbXEPRkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbXEPRkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:40:49 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:43959 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEPRkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:40:49 -0400
Date: Wed, 16 May 2007 18:40:47 +0100
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
Message-ID: <20070516174046.GE10225@skynet.ie>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <464B2048.7040103@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/05/07 08:16), H. Peter Anvin didst pronounce:
> Andy Whitcroft wrote:
> > Getting this on both x86 and x86_64 boxes, they are the older boxen so
> > likely older compilers:
> 
> Please give the gcc version number.
> 
> >   CC      arch/x86_64/boot/memory.o
> > arch/i386/boot/memory.c: In function `detect_memory':
> > arch/i386/boot/memory.c:32: error: can't find a register in class `DREG'
> > while reloading `asm'
> > 
> > Seems to come from git-netsetup, but that tree isn't pulled into your
> > git version of -mm so I can't be more specific.
> 
> Does the following patch work for you?
> 

With the patch, elm3b6 from test.kernel.org builds and boots. It's
x86_64. elm3b132 which is x86 fails with

  CC      arch/i386/boot/video-bios.o
  HOSTCC  arch/i386/boot/tools/build
  AS      arch/i386/boot/compressed/head.o
  CC      arch/i386/boot/compressed/misc.o
  OBJCOPY arch/i386/boot/compressed/vmlinux.bin
  LD      arch/i386/boot/setup.elf
ld:arch/i386/boot/setup.ld:47: syntax error
make[1]: *** [arch/i386/boot/setup.elf] Error 1
make[1]: *** Waiting for unfinished jobs....
  GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
include/asm/processor.h: In function `native_get_debugreg':
include/asm/processor.h:531: warning: asm operand 0 probably doesn't
match constraints
include/asm/processor.h: In function `native_set_debugreg':
include/asm/processor.h:558: warning: asm operand 0 probably doesn't
match constraints
  LD      arch/i386/boot/compressed/piggy.o
  LD      arch/i386/boot/compressed/vmlinux
make: *** [bzImage] Error 2
05/16/07-17:27:44 Build the kernel. Failed rc = 2
05/16/07-17:27:44 build: kernel build Failed rc = 1
Failed and terminated the run

I haven't checked yet if that has anything to do with git-newsetup or
not.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
