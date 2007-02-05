Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbXBEGln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbXBEGln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbXBEGlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:41:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:35197 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbXBEGlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YjhLej5oe8wYzEFwZRYFhPj2LpaWEe5mUp672swfA8OIk6qRNkD8ue6aCXVltGdJ3P46Kx9PeNqHBwB6CCS7tdpiQ+UdRn5ENZxMsJuaHj1ZxRUfJNWm2ve5SfHmXD2oHGVMzCbpZMUJp+YYZdI+z25oRaAoH8UNN7cOJ9fNn7s=
Message-ID: <aec7e5c30702042241s102a4ff3t475e0d3a22199da8@mail.gmail.com>
Date: Mon, 5 Feb 2007 15:41:37 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: Horms <horms@verge.net.au>
Subject: Re: [Fastboot] [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Magnus Damm" <magnus@valinux.co.jp>,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       nanhai.zou@intel.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070203032753.GE3709@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070201131347.3807.87075.sendpatchset@localhost>
	 <20070201163320.eb4fa2c7.akpm@osdl.org>
	 <aec7e5c30702011838g6e9edd23sc782321aacb07297@mail.gmail.com>
	 <aec7e5c30702020353h31fe9287nbf63612819a8c08f@mail.gmail.com>
	 <20070203032753.GE3709@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/07, Horms <horms@verge.net.au> wrote:
> On Fri, Feb 02, 2007 at 08:53:00PM +0900, Magnus Damm wrote:
> > On 2/2/07, Magnus Damm <magnus.damm@gmail.com> wrote:
> > > On 2/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > Magnus Damm <magnus@valinux.co.jp> wrote:
> > > >
> > > > > kexec: Fix CONFIG_SMP=n compilation (ia64)
> > > > >
> > > > > This patch makes it possible to compile kexec for ia64 without SMP support.
> > > > > --- 0002/arch/ia64/kernel/machine_kexec.c
> > > > > +++ work/arch/ia64/kernel/machine_kexec.c     2007-02-01 12:35:46.000000000 +0900
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

My mistake, the following lines from linux-2.6.20/arch/ia64/Kconfig
seem to handle this case already:

config KEXEC
	bool "kexec system call (EXPERIMENTAL)"
	depends on EXPERIMENTAL && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)

I'll send an updated patch in a short while. Thanks!

/ magnus
