Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbXBEBDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbXBEBDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 20:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXBEBDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 20:03:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:23399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbXBEBDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 20:03:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,279,1167638400"; 
   d="scan'208"; a="42877882:sNHT22497687"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Fastboot] [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Date: Mon, 5 Feb 2007 09:02:59 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A086BD4@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <20070203032753.GE3709@verge.net.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Fastboot] [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Thread-Index: AcdHRs64G++o4WIoSS2XL7sxWCiVWABegW6A
From: "Zou, Nanhai" <nanhai.zou@intel.com>
To: "Horms" <horms@verge.net.au>, "Magnus Damm" <magnus.damm@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Magnus Damm" <magnus@valinux.co.jp>,
       "Luck, Tony" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <fastboot@lists.osdl.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2007 01:03:16.0056 (UTC) FILETIME=[6AC56D80:01C748C1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Horms [mailto:horms@verge.net.au]
> Sent: 2007Äê2ÔÂ3ÈÕ 11:28
> To: Magnus Damm
> Cc: Andrew Morton; Magnus Damm; Luck, Tony; linux-ia64@vger.kernel.org; Zou,
> Nanhai; fastboot@lists.osdl.org; linux-kernel@vger.kernel.org
> Subject: Re: [Fastboot] [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
> 
> On Fri, Feb 02, 2007 at 08:53:00PM +0900, Magnus Damm wrote:
> > On 2/2/07, Magnus Damm <magnus.damm@gmail.com> wrote:
> > > On 2/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > Magnus Damm <magnus@valinux.co.jp> wrote:
> > > >
> > > > > kexec: Fix CONFIG_SMP=n compilation (ia64)
> > > > >
> > > > > This patch makes it possible to compile kexec for ia64 without SMP
> support.
> > > > > --- 0002/arch/ia64/kernel/machine_kexec.c
> > > > > +++ work/arch/ia64/kernel/machine_kexec.c     2007-02-01
> 12:35:46.000000000 +0900
> > > > > @@ -70,12 +70,14 @@ void machine_kexec_cleanup(struct kimage
> > > > >
> > > > >  void machine_shutdown(void)
> > > > >  {
> > > > > +#ifdef CONFIG_SMP
> > > > >       int cpu;
> > > > >
> > > > >       for_each_online_cpu(cpu) {
> > > > >               if (cpu != smp_processor_id())
> > > > >                       cpu_down(cpu);
> > > > >       }
> > > > > +#endif
> > > > >       kexec_disable_iosapic();
> > > > >  }
> > > >
> > > > hm.  I suspect this one should have been #ifndef CONFIG_HOTPLUG_CPU?
> >
> > Re-reading this I assume you mean #ifdef CONFIG_HOTPLUG_CPU.
> >
> > I would be happy to resend a new updated version of the patch, but I
> > wonder if it may be better to fail miserably during the build than
> > fail silently in the case of CONFIG_SMP=y but CONFIG_HOTPLUG_CPU=n.
> 
> There used to be alternate code for the CONFIG_SMP +
> !CONFIG_HOTPLUG_CPU, but this was removed because it was determined to
> be flakey and not maintainable (I can dig up the threads if you want).
> I think that this means that if we have CONFIG_KEXEC and CONFIG_SMP then
> CONFIG_HOTPLUG_CPU is required. I think this is expressable in Kconfig
> somehow.
> 


Yes, CONFIG_HOTPLUG_CPU is required by Kexec.
But CONFIG_HOTPLUG_CPU is not required by Kdump except SN platform.

Zou Nan hai
> --
> Horms
>   H: http://www.vergenet.net/~horms/
>   W: http://www.valinux.co.jp/en/
