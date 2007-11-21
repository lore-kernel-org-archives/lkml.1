Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXKUCm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXKUCm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXKUCmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:42:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbXKUCmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:42:18 -0500
Date: Tue, 20 Nov 2007 18:40:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
Message-Id: <20071120184048.2b8c82cd.akpm@linux-foundation.org>
In-Reply-To: <21076.1195608768@redhat.com>
References: <20071120125029.dfd58d83.akpm@linux-foundation.org>
	<200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<4742FACF.7040906@linux.vnet.ibm.com>
	<21076.1195608768@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 01:32:48 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > The patch
> > > aout-suppress-aout-library-support-if-config_arch_supports_aout.patch,
> > > creates a struct exec in linux/a.out.h and asm/a.out.h already has it, for
> > > the struct related warnings.
> 
> Nothing should be including {asm,linux}/a.out.h unless it absolutely needs it.
> I removed all the places it did so extraneously, after moving out STACK_TOP.

So... what went wrong with broken-out-2007-11-20-01-45.tar.gz?

> > OK, I've had it with trying to get that patch to vaguely work.  I'll drop
> > it and will then fix up the extensive dependency trail which it drags along
> > behind it.
> > 
> > David, please do not bring it back until it has had a *lot* of testing.
> 
> It compiles for all the archs for which I have a compiler, and the x86_64 and
> i386 kernels all build and boot for the following combinations of AOUT
> configs:
> 
> 	x86_64	CONFIG_IA32_AOUT=n
> 		CONFIG_IA32_AOUT=y
> 		CONFIG_IA32_AOUT=m
> 	i386	CONFIG_BINFMT_AOUT=n
> 		CONFIG_BINFMT_AOUT=y
> 		CONFIG_BINFMT_AOUT=m
> 
> It seems I had forgetten to include:
> 
> 	config ARCH_SUPPORTS_AOUT
> 		def_bool y
> 
> in arch/x86/Kconfig, but it builds without that too for both subarchs.
> 
> The kernel also builds and boots for MN10300 and FRV.
> 
> 
> The problem is that your -mm patchset doesn't match Linus's as a base.  I'm
> still not sure what the right procedure is for that.  I can give you some
> altered patches, but there's no guarantee you'll be able to pass them on to
> Linus without breaking his tree.  What do *you* want?

Often when people base a patch on -mm it is worse than basing it on
mainline - I usually prefer patches against mainline; partly because that's
less work for originators too.

But sometimes it doesn't work out very well.  There's lot of stuff
outstanding again.  Immediate problems are from an x86 exec randomisation
thingy in git-x86 and pie-executable-randomization.patch in -mm, which both
hit on binfmt_elf.c

