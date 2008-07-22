Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYGVGSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYGVGSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 02:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYGVGR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 02:17:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39072 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYGVGR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 02:17:56 -0400
Date: Tue, 22 Jul 2008 15:15:11 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Bernhard Walle <bwalle@suse.de>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068 trace_hardirqs_on_caller
Cc: Vivek Goyal <vgoyal@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>, Greg KH <gregkh@suse.de>,
       kexec <kexec@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, kernel-testers@vger.kernel.org
In-Reply-To: <20080721170037.1a0046b1@halley.suse.de>
References: <20080721133937.GC4451@redhat.com> <20080721170037.1a0046b1@halley.suse.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080722142345.8733.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> > > > Is /proc/iomem updated upon memory hotplug event.
> > > 
> > > Yes. I just checked that (yesterday).
> > > 
> > > I think it would make sense to extend /sys/firmware/memmap on
> > > hot-plugging. Just because on reboot, the firmware will see that
> > > memory, too, and report it. However, we need a way to discriminate the
> > > originally firmware-provided memory map with later added memory. I'm
> > > not sure how that can be done, I have to think about it.
> > 
> > Probably use another type of RAM identifier (System RAM (hotplug)).
> > 
> > But the point is, if /sys/devices/system/memory also represents all
> > the physical memory present in the system then it might be not be
> > justified to create another similar interface. (Until and unless there
> > is something unique about /sys/firmware/memmap).
> 
> But I don't see anything like a physical address there:
> 
>   /sys/devices/system/memory/memory2:
>   -r--r--r-- 1 root root 4096 2008-07-21 15:45 phys_device
>   -r--r--r-- 1 root root 4096 2008-07-21 15:45 phys_index
>   -rw-r--r-- 1 root root 4096 2008-07-21 15:45 state
> 
> (on a PPC64 machine where SUSE kernel has that interface enabled by
> default).

I wrote about them Documentation/memory-hotplug.txt. Please see it.

But I think /sys/firmware/memmap is better for kexec than using them.
They are made for each sections whose size is fixed on each architecture.
There is no information about areas which are occupied by firmware, and
its fixed size directories are not suitable to show them.


BTW, does kexec needs the information about not only hot-added normal memory
but also "hot-added occupied (reserved) memory by firmware"?
Fujitsu has ia64 box which can add memory. The information about memory
area is notified via _CRS method of ACPI. Our firmware team said that
there was no interface to notify the area which was occupied by firmware.
So, _CRS shows only normal (not-reserved) memory area. It means OS can't know
reserved memory which is hot-added.

If kexec has to know those reserved area, then it is very bad news for me. :-(


Thanks.

-- 
Yasunori Goto 


