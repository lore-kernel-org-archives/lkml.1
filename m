Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbZBETT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbZBETT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZBETTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:19:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZBETTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:19:50 -0500
Date: Thu, 5 Feb 2009 20:19:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090205191907.GA27422@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain> <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com> <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 5 Feb 2009, Tony Luck wrote:
> > 
> > Either revert this part ... or wrap the #include like this in fpu.h:
> > 
> > #ifndef __ASSEMBLY__
> > #include <linux/types.h>
> > #endif
> 
> That loses the
> 
> 	arch/ia64/include/asm/types.h:# define __IA64_UL(x)             (x)
> 
> thing from <asm/types.h>, and makes some of the constants unusable from 
> asm. Maybe nobody cares.
> 
> But it looks like that core really needs to use <asm/types.h> right now.

Note that these bits are not mainline yet, they are still being refined.

Jaswinder, because they can break the build we should proactively drop all 
architecture patches that do asm/types.h conversions.

I did build all the affected architectures via their defconfigs and they 
built just fine - but i cannot do wide coverage testing of them.

So i think we should drop these bits:

 earth4:~/tip> gll --grep='asm/types.h' linus..core/header-fixes
 1ff8f73: headers_check fix: xtensa, swab.h
 4810987: headers_check fix: powerpc, swab.h
 9f2cd96: headers_check fix: powerpc, kvm.h
 785857f: headers_check fix: powerpc, elf.h
 4be2c7f: headers_check fix: powerpc, bootx.h
 726da1e: headers_check fix: parisc, swab.h
 bef53ca: headers_check fix: mn10300, swab.h
 a9f6acc: headers_check fix: mips, swab.h
 d8cbec1: headers_check fix: m32r, swab.h
 040c92b: headers_check fix: ia64, swab.h
 6ce7950: headers_check fix: ia64, kvm.h
 fa9ea6c: headers_check fix: ia64, fpu.h
 295803e: headers_check fix: h8300, swab.h
 dacd762: headers_check fix: frv, swab.h
 350eb8b: headers_check fix: blackfin, swab.h
 1c6ce70: headers_check fix: avr32, swab.h
 e42ec24: headers_check fix: arm, swab.h
 4af3bf6: headers_check fix: arm, setup.h
 f100e6d: headers_check fix: arm, a.out.h
 3fd5906: headers_check fix: alpha, swab.h

and send the rest to Linus if all outstanding observations have been 
addressed. What do you think?

	Ingo
