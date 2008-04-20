Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYDTVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYDTVVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYDTVVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:21:30 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:57955 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYDTVV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:21:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEACNQC0hMROPA/2dsb2JhbACBUKdD
Date: Sun, 20 Apr 2008 17:21:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stringify support commas
Message-ID: <20080420212124.GA18039@Krystal>
References: <20080420183256.GA11350@Krystal> <20080420190631.GA6629@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080420190631.GA6629@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:19:39 up 51 days, 17:30,  3 users,  load average: 0.08, 0.10,
	0.14
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> On Sun, Apr 20, 2008 at 02:32:56PM -0400, Mathieu Desnoyers wrote:
> > #define MYDEF a, b, c
> > 
> > __stringify(MYDEF) should be replaced by "a, b, c", but compilation fails
> > because the __stringify macro expects only one argument. Fix it by using
> > variable macro arguments in __stringify and __stringify_1.
> > 
> > Needed in my current NMI safe iret paravirt support work so I can expand
> > a macro containing assembly code into a string.
> 
> This is a no-no for those archs that still use -traditional.
> I dunno if this is a problem for you at the moment and the
> right fix is anyway to nuke -traditional.
> 
> 	Sam

A quick grep through arch/ gives me the following :

arch/cris/arch-v10/boot/compressed/Makefile
        @$(CC) -D__ASSEMBLY__ -traditional -c $< -o $@
arch/cris/arch-v10/boot/rescue/Makefile
asflags-y += -traditional
arch/cris/arch-v10/lib/Makefile
EXTRA_AFLAGS := -traditional
arch/h8300/boot/compressed/Makefile
EXTRA_AFLAGS    := -traditional
arch/m32r/boot/compressed/Makefile
EXTRA_AFLAGS    := -traditional
arch/m32r/kernel/Makefile
EXTRA_AFLAGS    := -traditional
arch/m68k/fpsp040/Makefile
EXTRA_AFLAGS := -traditional
arch/m68k/ifpsp060/Makefile
EXTRA_AFLAGS := -traditional
arch/m68k/kernel/Makefile
EXTRA_AFLAGS := -traditional
arch/m68k/lib/Makefile
EXTRA_AFLAGS := -traditional
arch/m68k/math-emu/Makefile
EXTRA_AFLAGS := -traditional
arch/parisc/kernel/Makefile
AFLAGS_entry.o  := -traditional
AFLAGS_pacache.o := -traditional
arch/powerpc/boot/Makefile
BOOTAFLAGS      := -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
arch/s390/kernel/Makefile
EXTRA_AFLAGS    := -traditional
arch/s390/lib/Makefile
EXTRA_AFLAGS := -traditional
arch/s390/math-emu/Makefile
EXTRA_AFLAGS := -traditional
arch/sh/boot/compressed/Makefile_32
EXTRA_AFLAGS    := -traditional
arch/sh/boot/compressed/Makefile_64
EXTRA_AFLAGS    := -traditional

Would their removal break something ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
