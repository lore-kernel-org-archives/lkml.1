Return-Path: <linux-kernel-owner+w=401wt.eu-S1765975AbXKUBk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765975AbXKUBk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbXKUBkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:40:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759734AbXKUBkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:40:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071120125029.dfd58d83.akpm@linux-foundation.org>
References: <20071120125029.dfd58d83.akpm@linux-foundation.org> <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742FACF.7040906@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 21 Nov 2007 01:32:48 +0000
Message-ID: <21076.1195608768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > The patch
> > aout-suppress-aout-library-support-if-config_arch_supports_aout.patch,
> > creates a struct exec in linux/a.out.h and asm/a.out.h already has it, for
> > the struct related warnings.

Nothing should be including {asm,linux}/a.out.h unless it absolutely needs it.
I removed all the places it did so extraneously, after moving out STACK_TOP.

> OK, I've had it with trying to get that patch to vaguely work.  I'll drop
> it and will then fix up the extensive dependency trail which it drags along
> behind it.
> 
> David, please do not bring it back until it has had a *lot* of testing.

It compiles for all the archs for which I have a compiler, and the x86_64 and
i386 kernels all build and boot for the following combinations of AOUT
configs:

	x86_64	CONFIG_IA32_AOUT=n
		CONFIG_IA32_AOUT=y
		CONFIG_IA32_AOUT=m
	i386	CONFIG_BINFMT_AOUT=n
		CONFIG_BINFMT_AOUT=y
		CONFIG_BINFMT_AOUT=m

It seems I had forgetten to include:

	config ARCH_SUPPORTS_AOUT
		def_bool y

in arch/x86/Kconfig, but it builds without that too for both subarchs.

The kernel also builds and boots for MN10300 and FRV.


The problem is that your -mm patchset doesn't match Linus's as a base.  I'm
still not sure what the right procedure is for that.  I can give you some
altered patches, but there's no guarantee you'll be able to pass them on to
Linus without breaking his tree.  What do *you* want?

David
