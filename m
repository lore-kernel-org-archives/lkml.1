Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZITHnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZITHnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 03:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZITHnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 03:43:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZITHnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 03:43:31 -0400
Date: Sun, 20 Sep 2009 09:42:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090920074247.GA5733@elte.hu>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090919224430.GB9567@kroah.com> <1253419185.3253.21.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253419185.3253.21.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> Here is the patch which actually removes the vmi code.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> ---
> 
>  Documentation/kernel-parameters.txt |    2 
>  arch/x86/Kconfig                    |   10 
>  arch/x86/include/asm/vmi.h          |  269 ----------
>  arch/x86/include/asm/vmi_time.h     |   98 ----
>  arch/x86/kernel/Makefile            |    1 
>  arch/x86/kernel/setup.c             |    7 
>  arch/x86/kernel/smpboot.c           |    9 
>  arch/x86/kernel/vmi_32.c            |  913 -----------------------------------
>  arch/x86/kernel/vmiclock_32.c       |  321 ------------
>  9 files changed, 1 insertions(+), 1629 deletions(-)
>  delete mode 100644 arch/x86/include/asm/vmi.h
>  delete mode 100644 arch/x86/include/asm/vmi_time.h
>  delete mode 100644 arch/x86/kernel/vmi_32.c
>  delete mode 100644 arch/x86/kernel/vmiclock_32.c

The thing is, the overwhelming majority of vmware users dont benefit 
from hardware features like nested page tables yet. So this needs to be 
done _way_ more carefully, with a proper sunset period of a couple of 
kernel cycles.

This is as if Intel had sent a patch to desupport say Core2 
optimizations, now that Nehalem is out.

'Virtual hardware' is no different in this respect: until users benefit 
from something we want to keep it, even if the vendor would like to sell 
new hardware and would like the new hardware to have an edge over the 
installed base.

If we were able to rip out all (or most) of paravirt from arch/x86 it 
would be tempting for other technical reasons - but the patch above is 
well localized.

	Ingo
