Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYASVWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYASVWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYASVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:22:35 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58394 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYASVWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:22:34 -0500
Date: Sat, 19 Jan 2008 22:22:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: Help needed to fix section mismatch warnings
Message-ID: <20080119212242.GC29070@uranus.ravnborg.org>
References: <20080106140728.GA3504@uranus.ravnborg.org> <20080119115255.d114065f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119115255.d114065f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 11:52:55AM -0800, Randy Dunlap wrote:
> On Sun, 6 Jan 2008 15:07:28 +0100 Sam Ravnborg wrote:
> 
> > kbuild emit section mismatch warnings when it detects that someone does a
> > call from a non-init section to a init section.
> > The rationale here is that the init section are discarded at runtime and
> > if this call happens after the init section has gone we have an oops.
> > 
> > This check is planned to be turned into an error soon but we still
> > see a bit too many warnings.
> > 
> > To see the list below build a kernel like this:
> > 
> > make allyesconfig
> > Set CONFIG_HOTPLUG to n
> > (In General Setup | Configure standard kernel features | Support for hot-plugable devices)
> > 
> > Then build the kernel like this:
> > make KCFLAGS=-fno-unit-at-a-time
> > 
> > The flag "-fno-unit-at-a-time" tell gcc to avoid additional inlining which
> > otherwise would hide several section mismatch warnings.
> > 
> > With latest kernel I got 113 warnings and most should fixable.
> > Try to look at how other section mismatch warnings has been fixed for inspiration.
> > 
> > Patches can be cc:ed to me but always send it to the maintainer and lkml.
> > 
> > 	Sam
> > 
> > This is the current list of warnings
> > 
> > WARNING: vmlinux.o(.text+0x1ffd0): Section mismatch: reference to .init.text:register_cpu (between 'arch_register_cpu' and 'arch_unregister_cpu')
> 
> > WARNING: vmlinux.o(.text+0x21a39): Section mismatch: reference to .init.text:absent_pages_in_range (between 'reserve_hotadd' and 'unparse_node')
> > WARNING: vmlinux.o(.text+0x21ae9): Section mismatch: reference to .init.data: (between 'unparse_node' and 'null_slit_node_compare')
> 
> > WARNING: vmlinux.o(.text+0x38b43): Section mismatch: reference to .init.text:idle_regs (between 'fork_idle' and 'fork_traceflag')
> 
> Above 4 seem to be mostly fixed in -mm.  I made patches for them
> and then checked -mm, so I won't post the patches...
> 
> 
> > WARNING: vmlinux.o(.text+0x43524): Section mismatch: reference to .init.text: (between 'timer_cpu_notify' and 'msleep')
> > WARNING: vmlinux.o(.text+0x4c6f6): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')
> > WARNING: vmlinux.o(.text+0x51cbe): Section mismatch: reference to .init.text: (between 'hrtimer_cpu_notify' and 'down_read_trylock')
> 
> I'll post patches for the 3 above.  However, the rcu code in -mm
> is quite different, so the rcu patch may have a short life.

Hi Randy.

Thanks for your efforts!

	Sam
