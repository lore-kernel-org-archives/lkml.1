Return-Path: <linux-kernel-owner+w=401wt.eu-S1946317AbXBCDxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946317AbXBCDxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 22:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946316AbXBCDxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 22:53:01 -0500
Received: from koto.vergenet.net ([210.128.90.7]:53545 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946312AbXBCDxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 22:53:00 -0500
Date: Sat, 3 Feb 2007 12:27:54 +0900
From: Horms <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus@valinux.co.jp>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, nanhai.zou@intel.com,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Message-ID: <20070203032753.GE3709@verge.net.au>
References: <20070201131347.3807.87075.sendpatchset@localhost> <20070201163320.eb4fa2c7.akpm@osdl.org> <aec7e5c30702011838g6e9edd23sc782321aacb07297@mail.gmail.com> <aec7e5c30702020353h31fe9287nbf63612819a8c08f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30702020353h31fe9287nbf63612819a8c08f@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 08:53:00PM +0900, Magnus Damm wrote:
> On 2/2/07, Magnus Damm <magnus.damm@gmail.com> wrote:
> > On 2/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Magnus Damm <magnus@valinux.co.jp> wrote:
> > >
> > > > kexec: Fix CONFIG_SMP=n compilation (ia64)
> > > >
> > > > This patch makes it possible to compile kexec for ia64 without SMP support.
> > > > --- 0002/arch/ia64/kernel/machine_kexec.c
> > > > +++ work/arch/ia64/kernel/machine_kexec.c     2007-02-01 12:35:46.000000000 +0900
> > > > @@ -70,12 +70,14 @@ void machine_kexec_cleanup(struct kimage
> > > >
> > > >  void machine_shutdown(void)
> > > >  {
> > > > +#ifdef CONFIG_SMP
> > > >       int cpu;
> > > >
> > > >       for_each_online_cpu(cpu) {
> > > >               if (cpu != smp_processor_id())
> > > >                       cpu_down(cpu);
> > > >       }
> > > > +#endif
> > > >       kexec_disable_iosapic();
> > > >  }
> > >
> > > hm.  I suspect this one should have been #ifndef CONFIG_HOTPLUG_CPU?
> 
> Re-reading this I assume you mean #ifdef CONFIG_HOTPLUG_CPU.
> 
> I would be happy to resend a new updated version of the patch, but I
> wonder if it may be better to fail miserably during the build than
> fail silently in the case of CONFIG_SMP=y but CONFIG_HOTPLUG_CPU=n.

There used to be alternate code for the CONFIG_SMP +
!CONFIG_HOTPLUG_CPU, but this was removed because it was determined to
be flakey and not maintainable (I can dig up the threads if you want).
I think that this means that if we have CONFIG_KEXEC and CONFIG_SMP then
CONFIG_HOTPLUG_CPU is required. I think this is expressable in Kconfig
somehow.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

