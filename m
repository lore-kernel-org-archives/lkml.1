Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYDKQEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYDKQEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYDKQE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:04:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:23644 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760105AbYDKQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:04:26 -0400
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20080411153728.GG27073@phobos.i.cabal.ca>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org>
	 <20080410223738.80A8326F992@magilla.localdomain>
	 <20080411114654.GA12270@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
	 <20080411151156.GJ9785@ZenIV.linux.org.uk>
	 <alpine.LFD.1.00.0804110821400.3143@woody.linux-foundation.org>
	 <20080411153728.GG27073@phobos.i.cabal.ca>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 11 Apr 2008 18:03:07 +0200
Message-Id: <1207929787.21379.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 11:37 -0400, Kyle McMartin wrote:
> On Fri, Apr 11, 2008 at 08:25:05AM -0700, Linus Torvalds wrote:
> > On Fri, 11 Apr 2008, Al Viro wrote:
> > > and that gets us -traditional-cpp passed to cc1, with obvious resulting
> > > unhappiness from vararg macro.
> > 
> > Yeah, I figured it out eventually. 
> > 
> > I do think the architectures should try to avoid it, if only because x86 
> > doesn't use -traditional (so they'll hit things like this unnecessarily 
> > otherwise), but I'll apply Heiko's minimal patch in the meantime.
> > 
> 
> Cool with me; I'll try to puzzle out why removing -traditional breaks on
> those two specific files. Ugh, big cleanups likely.

So there is at least one architecture that really requires -traditional,
it is not an option to just remove them. For s390 the kernel compiles
fine without -traditional on the AFLAGS so we can as well remove them.
I'll queue the patch below. In the meantime Heikos patch will have to
do.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
[PATCH] s390: remove -traditional from AFLAGS

From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 4d3e383..cfb6ccc 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-EXTRA_AFLAGS	:= -traditional
+EXTRA_AFLAGS	:= 
 
 #
 # Passing null pointers is ok for smp code, since we access the lowcore here.
diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 5208443..dd6f9f5 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for s390-specific library files..
 #
 
-EXTRA_AFLAGS := -traditional
+EXTRA_AFLAGS := 
 
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o
diff --git a/arch/s390/math-emu/Makefile b/arch/s390/math-emu/Makefile
index 73b3e72..42828d3 100644
--- a/arch/s390/math-emu/Makefile
+++ b/arch/s390/math-emu/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_MATHEMU) := math.o
 
 EXTRA_CFLAGS := -I$(src) -Iinclude/math-emu -w
-EXTRA_AFLAGS := -traditional
+EXTRA_AFLAGS := 


