Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXBBD5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXBBD5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 22:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933207AbXBBD53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 22:57:29 -0500
Received: from koto.vergenet.net ([210.128.90.7]:48024 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbXBBD52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 22:57:28 -0500
Date: Fri, 2 Feb 2007 12:57:15 +0900
From: Horms <horms@verge.net.au>
To: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus@valinux.co.jp>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Message-ID: <20070202035714.GE16554@verge.net.au>
References: <aec7e5c30702011838g6e9edd23sc782321aacb07297@mail.gmail.com> <10EA09EFD8728347A513008B6B0DA77A086BD0@pdsmsx411.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10EA09EFD8728347A513008B6B0DA77A086BD0@pdsmsx411.ccr.corp.intel.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 11:01:21AM +0800, Zou, Nanhai wrote:
> > > >  void
> > > >  machine_crash_shutdown(struct pt_regs *pt)
> > > > @@ -132,11 +134,12 @@ kdump_cpu_freeze(struct unw_frame_info *
> > > >       atomic_inc(&kdump_cpu_freezed);
> > > >       kdump_status[cpuid] = 1;
> > > >       mb();
> > > > -     if (cpuid == 0) {
> > > > -             for (;;)
> > > > -                     cpu_relax();
> > > > -     } else
> > > > +#ifdef CONFIG_HOTPLUG_CPU
> > > > +     if (cpuid != 0)
> > > >               ia64_jump_to_sal(&sal_boot_rendez_state[cpuid]);
> > > > +#endif
> > > > +     for (;;)
> > > > +             cpu_relax();
> > > >  }
> > >
> > > I trust ia64_jump_to_sal doesn't return.
> > 
> > So do I. The main problem with the compilation seems to be that
> > ia64_jump_to_sal() only exists if CONFIG_HOTPLUG_CPU=y.
> > (include/asm-ia64/sal.h, arch/ia64/kernel/head.S)
> > 
>  This may cause problem on SN platform. 
> I remember SN requires cpu0 return to SAL rendez loop to do IRQ redirection.
> However this needs SGI people to confirm...

Does this mean that CONFIG_HOTPLUG_CPU may be required for kdump
on the SN platform?

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

