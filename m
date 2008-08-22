Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYHVTVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYHVTVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYHVTU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:20:57 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:3050 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYHVTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:20:56 -0400
X-BigFish: VPS-63(zz1432R98dR936eQ62a3L1805M179dR936fQ9371Pzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K60OEG-01-KP0-01
Date: Fri, 22 Aug 2008 21:20:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix: make PCI ECS for AMD CPUs hotplug capable
Message-ID: <20080822192023.GD14103@erda.amd.com>
References: <48AD82D5.76E4.0078.0@novell.com> <1219429418-29023-2-git-send-email-robert.richter@amd.com> <86802c440808221156h7ef48973hb5db8cf2b01ac27b@mail.gmail.com> <20080822190724.GB14103@erda.amd.com> <86802c440808221210x40057476p5566d0dc82032608@mail
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440808221210x40057476p5566d0dc82032608@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Aug 2008 19:20:46.0043 (UTC) FILETIME=[2D670AB0:01C9048C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.08.08 12:10:04, Yinghai Lu wrote:
> On Fri, Aug 22, 2008 at 12:07 PM, Robert Richter <robert.richter@amd.com> wrote:
> > On 22.08.08 11:56:08, Yinghai Lu wrote:
> >
> > [...]
> >
> >> > +static int __init pci_io_ecs_init(void)
> >> > +{
> >> > +       int cpu;
> >> > +
> >> >        /* assume all cpus from fam10h have IO ECS */
> >> >         if (boot_cpu_data.x86 < 0x10)
> >> >                return 0;
> >> > -       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1);
> >> > +
> >> > +       register_cpu_notifier(&amd_cpu_notifier);
> >> > +       for_each_online_cpu(cpu)
> >> > +               amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
> >> > +                              (void *)(long)cpu);
> >>
> >> wonder if those two lines should be reversed.
> >
> > Do you mean setting PCI_HAS_IO_ECS before for_each_online_cpu(...)?
> > PCI_HAS_IO_ECS will be used only in pci_direct_init(). PCI is
> > initialized in a later init stage, so it doesn't matter. My intention
> > was to set the bit after the setup of all online cpus is finished.
> 
> 
> ==>
> +       for_each_online_cpu(cpu)
> +               amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
> +                              (void *)(long)cpu);
> +       register_cpu_notifier(&amd_cpu_notifier);

Hmm, most code in the kernel registers first. Theoretical, with this
code, if a cpu would go online in between, it wouldn't be initialized.

-Robert

> 
> YH
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

