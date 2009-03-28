Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZC1QNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZC1QNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZC1QM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:12:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:41293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZC1QM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:12:57 -0400
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Joerg Roedel <joro@8bytes.org>
In-Reply-To: <20090328155837.GA3503@x200.localdomain>
References: <1238251730.2526.2.camel@ht.satnam>
	 <20090328150746.GA3268@x200.localdomain>
	 <20090328155549.47c9cdc5@the-village.bc.nu>
	 <20090328155837.GA3503@x200.localdomain>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 21:41:50 +0530
Message-Id: <1238256710.2526.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 18:58 +0300, Alexey Dobriyan wrote:
> On Sat, Mar 28, 2009 at 03:55:49PM +0000, Alan Cox wrote:
> > > kenel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> > > > 
> > > > Jaswinder Singh Rajput (49):
> > > >       x86: process_32.c include inverse Xmas tree effect
> > > 
> > > What the heck is this?
> > 
> > Does inverse christmas tree effect not translate well. It could perhaps
> > have been more clearly explained.
> > 
> > Getting the includes under control is a good thing and saves everyone
> > time.
> 
> Moving #includes up and down is not getting them under control.

Here is Ingo's response about this effect:

On Sun, 2009-03-15 at 05:54 +0100, Ingo Molnar wrote: 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > >  #include <linux/debugfs.h>
> > >  #include <linux/uaccess.h>
> > > -#include <linux/stat.h>
> > > +#include <linux/module.h>
> > >  #include <linux/init.h>
> > > +#include <linux/stat.h>
> > >  #include <linux/io.h>
> > >  #include <linux/mm.h>
> > > -#include <linux/module.h>
> > >  
> > 
> > Just curious about the rule to sort those includes, and why they need
> > to be rearranged.
> 
> Such includes (the 'reverse christmas tree'):
> 
> #include <linux/interrupt.h>
> #include <linux/mmiotrace.h>
> #include <linux/bootmem.h>
> #include <linux/compiler.h>
> #include <linux/highmem.h>
> #include <linux/kprobes.h>
> #include <linux/uaccess.h>
> #include <linux/vmalloc.h>
> #include <linux/vt_kern.h>
> #include <linux/signal.h>
> #include <linux/kernel.h>
> #include <linux/ptrace.h>
> #include <linux/string.h>
> #include <linux/module.h>
> #include <linux/kdebug.h>
> #include <linux/errno.h>
> #include <linux/magic.h>
> #include <linux/sched.h>
> #include <linux/types.h>
> #include <linux/init.h>
> #include <linux/mman.h>
> #include <linux/tty.h>
> #include <linux/smp.h>
> #include <linux/mm.h>
> 
> #include <asm/kmemcheck.h>
> #include <asm/tlbflush.h>
> #include <asm/pgalloc.h>
> #include <asm/segment.h>
> #include <asm/system.h>
> #include <asm/proto.h>
> #include <asm/traps.h>
> #include <asm/desc.h>
> 
> are used by x86 architecture code (and some other subsystems) to 
> reduce the likelyhood of patch conflicts in commonly modified 
> kernel files.
> 
> Without such ordering developers typically append to the 
> existing list of include files when introducing a new header - 
> creating an almost certain patch conflict. Via the above 
> ordering, new headers get distributed roughly evenly amongst the 
> full range - and thus the chance of patch conflicts is much 
> smaller.
> 
> This way it also looks a bit more structured and bit less messy. 
> It looks unprofessional and sloppy if a .c file starts with a 
> big block of thrown-together include files.
> 
> 	Ingo


