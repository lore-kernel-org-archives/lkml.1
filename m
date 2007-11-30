Return-Path: <linux-kernel-owner+w=401wt.eu-S934925AbXK3Of5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925AbXK3Of5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXK3Oft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:35:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbXK3Oft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:35:49 -0500
Date: Fri, 30 Nov 2007 09:35:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071130143534.GB23810@redhat.com>
References: <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com> <m1d4tudun5.fsf@ebiederm.dsl.xmission.com> <474F7290.8010504@redhat.com> <m1sl2oa1ev.fsf@ebiederm.dsl.xmission.com> <86802c440711300059tb8bf924i72a9eca29723499f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440711300059tb8bf924i72a9eca29723499f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 12:59:26AM -0800, Yinghai Lu wrote:
> On Nov 29, 2007 6:54 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Ben Woodard <woodard@redhat.com> writes:
> >
> >
> > > Eric W. Biederman wrote:
> > >> Vivek Goyal <vgoyal@redhat.com> writes:
> > >>
> > >>> Ok. Got it. So in this case we route the interrupts directly through LAPIC
> > >>> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
> > >>>
> > >>> I am looking at Intel Multiprocessor specification v1.4 and as per figure
> > >>> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is
> > >>> connected to LINTIN0 pin on all processors. If that is the case, even in
> > >>> this mode, all the CPU should see the timer interrupts (which is coming
> > >>> from 8259)?
> > >>
> 
> there is two mode for mcp55. bios should have one option about virtul
> wired to LVT0 of BSP or IOAPIC pin 0.
> or the option like hpet route to ioapic pin 2.
> 

That's interesting. So with BIOS options I can force timer 
interrupts to be routed through IOAPIC? That would enable us to get
timer interrupts on any of the cpus in legacy mode. Ben, can you give it
a try?

> for kdump fix, could enable LVT0 of CPU for kdump and disable that for BSP?

We would not know the crashing cpu in advance hence can't set it. 

Thanks
Vivek
