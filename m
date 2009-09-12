Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZILFCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZILFCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbZILFCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 01:02:40 -0400
Received: from kuber.nabble.com ([216.139.236.158]:60857 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZILFCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 01:02:39 -0400
Message-ID: <25411648.post@talk.nabble.com>
Date: Fri, 11 Sep 2009 22:02:42 -0700 (PDT)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Controlling memory allocation
In-Reply-To: <3e8340490909112037p3b4d4f32p2dc6dda01cfcb8ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <25410990.post@talk.nabble.com> <3e8340490909112037p3b4d4f32p2dc6dda01cfcb8ea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for your quick reply. I understand that user processes can go anywhere
in memory and are least restricted. So what I am trying to do is to simulate
a system which has two different memory technologies forming the main memory
subsystem. And I am looking to simulate this on a real system which
obviously has only DRAM available, so I was wondering if the kernel can
restrict a particular process to get only pages from a particular part of
the DRAM, and I understand they wont be contiguos and some other
applications might take up the other available frames in that region, so in
essence what I am trying to do is to say that for a particular process (or a
set of processes) only a certain part of the DRAM is available, and when the
kernel runs out of memory on this region that it is using for this process,
it does what is done when no free frame is found, swap out another frame to
make space for this request.

I hope I am making some sense, so in essence my question can be re-framed
as, can the kernel "virtualize" memory for a particular process so only a
particular region of the memory is available for that particular process and
all other activities like page allocation and replacement take place for
this process only within this region and rest of the system functions
normally with the entire memory available for use

Thanks once again for your reply and I really appreciate all the help

Regards,
SC

Bryan Donlan wrote:
> 
> On Fri, Sep 11, 2009 at 10:23 PM, sidc7 <siddhartha.chhabra@gmail.com>
> wrote:
>>
>> I had a question regarding memory allocation. On a contemporary system,
>> the
>> kernel will allocate physical frames on the DRAM based on availability.
>> Is
>> it possible for the kernel to somehow restrict frame allocation for a
>> particular process to a particular address range. For e.g. Lets assume
>> the
>> DRAM ranges from 00-FF, on a contemporary system, the entire range is
>> available for the kernel to allocate to the processes. Is it possible for
>> the kernel to say PID 1: the frames will be allocated only in 00-A0,
>> PID2:
>> the frames will be allocated from A1 - D0 and PID3: will get frames from
>> D1
>> - FF.
> 
> The kernel has a concept of 'zones' that can be used to restrict
> allocations as you say - however, user processes are the _least_
> restricted. These zones are used to deal with old devices that can't
> do DMAs above 16mb (so memory for their DMA buffers is allocated from
> the 'DMA' zone), as well as to keep the kernel's internal
> datastructures within the first 700mb or so of RAM (zone 'normal').
> Memory used directly by userspace processes, including cache, can come
> from any zone, including zone 'highmem'.
> 
> There's also some work on NUMA memory allocation policies - I'm not
> too familiar with the details, but it does involve setting a
> preference that pages for certain user processes get allocated from
> certain memory banks near the CPU(s) that are executing the process.
> 
> Note that in both cases the assignments are somewhat static - zones
> are set at compile time and are used solely as a workaround for
> hardware limitations; exactly which are used depend on your
> architecture (although the _types_ of zones available are fixed). See
> include/linux/mmzones.h NUMA is determined by your hardware
> configuration. And processes are never assigned just a contiguous,
> exclusive range of pages to use, as there's no benefit in doing so -
> what happens if something else took some of those first and it runs
> out, after all?
> 
> For more information about zones, see
> http://lxr.linux.no/linux+v2.6.31/include/linux/mmzone.h#L190 and the
> x86 arch init code starting at
> http://lxr.linux.no/linux+v2.6.31/arch/x86/mm/init_32.c#L737 etc.
> For more info on NUMA, see the userspace API at
> http://linux.die.net/man/3/numa and the paper at
> http://www.kernel.org/pub/linux/kernel/people/christoph/pmig/numamemory.pdf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/Controlling-memory-allocation-tp25410990p25411648.html
Sent from the linux-kernel mailing list archive at Nabble.com.

