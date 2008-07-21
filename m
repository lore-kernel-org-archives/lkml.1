Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYGUNTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYGUNTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYGUNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:19:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbYGUNTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:19:21 -0400
Date: Mon, 21 Jul 2008 09:17:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Greg KH <gregkh@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>, kexec <kexec@lists.infradead.org>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
Message-ID: <20080721131721.GB4451@redhat.com>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au> <200807190928.33978.m.kozlowski@tuxland.pl> <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com> <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com> <20080719221723.GB5578@suse.de> <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com> <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com> <20080719225817.GA6264@suse.de> <19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com> <1216544462.9311.20.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216544462.9311.20.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 02:01:02AM -0700, Dave Hansen wrote:
> On Sun, 2008-07-20 at 01:11 +0200, Vegard Nossum wrote:
> > Maybe the firmware memmap code can simply run a little later in the
> > boot sequence?
> 
> Heh, I'm catching up on this thread...
> 
> It is possible that it could run later.  But, I do know that there are
> at least a couple of these tables (on various arches) that we toss out
> of memory or become unavailable later in boot.  
> 
> I do this this:
> 
>     sysfs: add /sys/firmware/memmap
> 
> is really being done at the wrong level.  I don't, for instance, see
> *any* reference to memory hotplug in these patches.  That's because
> they're done against firmware structures, and memory hotplug doesn't
> update firmware structures on the two architectures that I can remember
> (ppc64 and x86).
> 
> In other words, kexec using this probably won't work on a memory hotplug
> machine.

If memory is just being added and not being removed then kexec will
continue to work. Just that newly added memory will not be visible to
second kernel. (Unless we start modifying /sys/firmware/memmap upon 
memory hotplug event).

Is /proc/iomem updated upon memory hotplug event. All these years, kexec
has been using that interace.

> 
> Secondly, why don't we just modify the
> existing /sys/devices/system/memory things to properly export what exec
> needs?  They're already cross-platform *and* they're updated with memory
> hotplug events.  

As bernhard mentioned that above interface has got long dependeny list
and will not work for kexec until and unless we get rid of those 
dependencies.

What does /sys/devices/system/memory represent? All the physical memory
present in the system or all the physical memory being used by kernel
(for example, memory limited by command line options mem=).

If it represents all the physical memory present in the system then it
might make sense to not create another interface but to use this one for
kexec. (But we shall have to get rid of long list of dependencies so that
it can gel wil more universal appeal of kexec).

Do you think that we can decouple /sys/devices/system/memory interface with
CONFIG_MEMORY_HOTPLUG?

Thanks
Vivek
