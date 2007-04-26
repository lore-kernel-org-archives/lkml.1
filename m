Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbXDZON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbXDZON4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXDZON4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:13:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbXDZONz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:13:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error II
Date: Thu, 26 Apr 2007 16:13:41 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630980D.7010904@shadowen.org> <20070426132736.GA16909@skynet.ie>
In-Reply-To: <20070426132736.GA16909@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261613.41717.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 15:27:36 Mel Gorman wrote:
> On (26/04/07 13:16), Andy Whitcroft didst pronounce:
> > Getting the following on an x86_64 numa box:
> > 
> >   CC      arch/x86_64/vdso/vclock_gettime.o
> > arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
> > supported in the 32 bit mode
> > make[1]: *** [arch/x86_64/vdso/vclock_gettime.o] Error 1
> > make: *** [arch/x86_64/vdso] Error 2
> > 
> > Kernel config here: http://test.kernel.org/abat/85358/build/dotconfig
> > 
> 
> Hi Andi,
> 
> Backing out x86_64-mm-vdso.patch allowed this kernel to build and boot
> successful on the machine in question (elm3b6). The backout caused one reject
> in Documentation/kernel-parameters but otherwise backed out easily. It's
> not super-clear why it fails to build. If you want me to try another patch,
> make sure I'm cc'd and I'll give it a spin.


Or please try this simple patch.

-Andi

Index: linux/arch/x86_64/vdso/Makefile
===================================================================
--- linux.orig/arch/x86_64/vdso/Makefile
+++ linux/arch/x86_64/vdso/Makefile
@@ -32,7 +32,7 @@ $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso
 $(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
 
-CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables
+CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CF)
 $(obj)/vgetcpu.o: CFLAGS = $(CF)
