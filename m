Return-Path: <linux-kernel-owner+w=401wt.eu-S1031055AbXDZObF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031055AbXDZObF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031030AbXDZObE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:31:04 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:52785 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031141AbXDZObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:31:03 -0400
Date: Thu, 26 Apr 2007 15:31:01 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error
Message-ID: <20070426143101.GC16909@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630980D.7010904@shadowen.org> <20070426132736.GA16909@skynet.ie> <200704261611.29121.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200704261611.29121.ak@suse.de>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 16:11), Andi Kleen didst pronounce:
> On Thursday 26 April 2007 15:27:36 Mel Gorman wrote:
> > On (26/04/07 13:16), Andy Whitcroft didst pronounce:
> > > Getting the following on an x86_64 numa box:
> > > 
> > >   CC      arch/x86_64/vdso/vclock_gettime.o
> > > arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
> > > supported in the 32 bit mode
> 
> 32bit mode?  Something must be confused.
> 
> What gcc/binutils is that?

gcc -v
gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13sarge1)

ld -v
GNU ld version 2.15

> 
> Can you post V=1 output for that line please?

make -f scripts/Makefile.build obj=arch/x86_64/vdso
  gcc -Wp,-MD,arch/x86_64/vdso/.vclock_gettime.o.d  -nostdinc -isystem
/usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h  -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(vclock_gettime)" -D"KBUILD_MODNAME=KBUILD_STR(vclock_gettime)" -c -o arch/x86_64/vdso/vclock_gettime.o arch/x86_64/vdso/vclock_gettime.c
arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
supported in the 32 bit mode
make[1]: *** [arch/x86_64/vdso/vclock_gettime.o] Error 1
make: *** [arch/x86_64/vdso] Error 2

> 
> It works for me with gcc 4.1 and 3.3
> 

Will try the patch.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
