Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXLaBEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXLaBEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXLaBDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:03:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:16928 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbXLaBDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PDnlWntdwkp6I2OkCyppnGxqaOTpoeRk0E3u20XP1eEB/gYc8cIbXkxQkCFO9nT51XYJsZPOR3dnasR93euaiVp1QOFtnZX4Jkhvqp7TBVn0pbKC5DOMJsudIdFx4xf8YxHZ2qxnXJgW+4CWh25HxCnU+Ey+NuQt92runqxEkDM=
Message-ID: <86802c440712301703w1929ae9fue5bf937bf7f4e005@mail.gmail.com>
Date: Sun, 30 Dec 2007 17:03:50 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error vector. v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071231002845.GB3083@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712291952.20455.yinghai.lu@sun.com>
	 <20071230145115.GR16946@elte.hu>
	 <86802c440712301248m38cd000ejf7e48f273d573edd@mail.gmail.com>
	 <20071230220620.GC17670@does.not.exist>
	 <86802c440712301442q476979f0hef047a45e5444c84@mail.gmail.com>
	 <20071230232354.GA3083@does.not.exist>
	 <86802c440712301601g62448de8i412895a105a9ae61@mail.gmail.com>
	 <20071231002845.GB3083@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 4:28 PM, Adrian Bunk <bunk@kernel.org> wrote:
>
> On Sun, Dec 30, 2007 at 04:01:39PM -0800, Yinghai Lu wrote:
> > On Dec 30, 2007 3:23 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > >
> > > On Sun, Dec 30, 2007 at 02:42:41PM -0800, Yinghai Lu wrote:
> > > > On Dec 30, 2007 2:06 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > > > > On Sun, Dec 30, 2007 at 12:48:48PM -0800, Yinghai Lu wrote:
> > > > > > On Dec 30, 2007 6:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > > > >
> > > > > > > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > > > > > >
> > > > > > > > please check if you can replace the one in the x86-mm
> > > > > > > >
> > > > > > > > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76
> > > > > > > >
> > > > > > > > the updated one avoid one link warning.
> > > > > > >
> > > > > > > please send delta patches instead - so that we can review the changes.
> > > > > >
> > > > > > will do that in another patch.
> > > > > >
> > > > > > >
> > > > > > > > this is the updated verison that take enable_IO_APIC as extra call for
> > > > > > > > setup_local_APIC to avoid linking warning.
> > > > > > >
> > > > > > > hm, what link warning did you get? Perhaps the following __cpuinit:
> > > > > >
> > > > > > WARNING: vmlinux.o(.text+0x163d5): Section mismatch: reference to
> > > > > > .init.text:enable_IO_APIC (between 'setup_local_APIC' and
> > > > > > 'apic_is_clustered_box')
> > > > >
> > > > > So you are doing complicated things for silencing the warning (there is
> > > > > an easier ways for achieving it), but the real bug that you will get an
> > > > > Oops when calling enable_IO_APIC() after bootup since it already got
> > > > > freed stays?
> > > >
> > > > the enable_IO_APIC is actually doing clear_IO_APIC. and it is only
> > > > called by BSP via setup_local_APIC
> > > > and it is not called again after bootup
> > >
> > > OK, this was a bit hidden inside your pointer games.
> > >
> > > Please send a patch that ignores the warning (and therefore doesn't do
> > > these pointer games), and I'll fix the warning in a followup patch.
> >
> > the old one is in x86-mm tree
> >
> > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76
> >...
>
> Sorry for the dumb question, but what in
>
> +       if (!smp_processor_id() && !skip_ioapic_setup && nr_ioapics)
> +               enable_IO_APIC();
>
> guarantees that this call doesn't happen when you hotplug CPU 0 ?
>

if CPU 0 (BSP) can be hotplug, it will be restarted via smp_callin.
and the delta function call patch will use setup_local_APIC(NULL),
then it will be safe.

YH
