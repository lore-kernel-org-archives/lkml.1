Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYBHTWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYBHTWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYBHTV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:21:56 -0500
Received: from ns.suse.de ([195.135.220.2]:38104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYBHTVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:21:55 -0500
Date: Fri, 8 Feb 2008 11:19:14 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: [patch 43/45] x86: replace LOCK_PREFIX in futex.h
Message-ID: <20080208191914.GA13589@suse.de>
References: <20080207204118.202098927@mini.kroah.org> <20080207204821.GR16389@suse.de> <200802081935.34666.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802081935.34666.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 07:35:33PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Donnerstag, 7. Februar 2008, Greg KH wrote:
> > 2.6.24-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > The exception fixup for the futex macros __futex_atomic_op1/2 and
> > futex_atomic_cmpxchg_inatomic() is missing an entry when the lock
> > prefix is replaced by a NOP via SMP alternatives.
> > 
> > Chuck Ebert tracked this down from the information provided in:
> > https://bugzilla.redhat.com/show_bug.cgi?id=429412
> > 
> > A possible solution would be to add another fixup after the
> > LOCK_PREFIX, so both the LOCK and NOP case have their own entry in the
> > exception table, but it's not really worth the trouble.
> > 
> > Simply replace LOCK_PREFIX with lock and keep those untouched by SMP
> > alternatives.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  include/asm-x86/futex_32.h |    6 +++---
> >  include/asm-x86/futex_64.h |    6 +++---
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> This patch seems to break compilation on x86_64 (i386 builds fine).
> 
> [...]
>   CC      kernel/time/tick-sched.o
>   LD      kernel/time/built-in.o
>   CC      kernel/futex.o
> In file included from include/asm/futex.h:4,
>                  from kernel/futex.c:59:
> include/asm/futex_64.h: In function ???futex_atomic_op_inuser???:
> include/asm/futex_64.h:69: error: expected ???:??? or ???)??? before ???lock???
> include/asm/futex_64.h:69: error: stray ???\??? in program
> In file included from include/asm/futex.h:4,
>                  from kernel/futex.c:59:
> include/asm/futex_64.h:69:61: error: invalid suffix "b" on integer constant
> include/asm/futex_64.h:69: error: stray ???\??? in program
> include/asm/futex_64.h:69: error: stray ???\??? in program
> include/asm/futex_64.h:72: error: expected ???:??? or ???)??? before ???lock???
> include/asm/futex_64.h:72: error: stray ???\??? in program
> include/asm/futex_64.h:72:63: error: invalid suffix "b" on integer constant
> include/asm/futex_64.h:72: error: stray ???\??? in program
> include/asm/futex_64.h:72: error: stray ???\??? in program
> include/asm/futex_64.h:75: error: expected ???:??? or ???)??? before ???lock???
> include/asm/futex_64.h:75: error: stray ???\??? in program
> include/asm/futex_64.h:75:62: error: invalid suffix "b" on integer constant
> include/asm/futex_64.h:75: error: stray ???\??? in program
> include/asm/futex_64.h:75: error: stray ???\??? in program
> include/asm/futex_64.h:51: warning: unused variable ???tem???
> make[1]: *** [kernel/futex.o] Fehler 1
> make: *** [kernel] Fehler 2

Ugh, my x86-64 assember knowledge sucks and I don't see how to easily
fix this, so I'll drop it for now and wait for Thomas to send a new
patch for the next .24 -stable release.

thanks a lot for the report,

greg k-h
