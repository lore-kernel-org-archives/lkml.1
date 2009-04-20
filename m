Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZDTOWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZDTOWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZDTOWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:22:22 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:39936 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZDTOWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Q2LE6RM7x255sdeUlhV6W9q1n3Ltged8SjukEksW8Iurelc5QwRQEDns09IF7nyIQa
         vujBxVNVGkuRr0icYyjyr1TYsJu5AZ4xnpd8xkA7xDnEgWSyTbUsnSyfKAEKwhb4v3L4
         SzRl/hXo/kL+yl+1gHuTMDvO4f+PXFjNPC3bs=
Subject: Re: "RT_PREEMPT for loongson" is updated to patch-2.6.29.1-rt8
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Zhang Le <r0bertz@gentoo.org>, linux-kernel@vger.kernel.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, zhangfx@lemote.com,
       loongson-dev@googlegroups.com, yanh@lemote.com,
       linux-mips@linux-mips.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090420131022.GA10183@linux-mips.org>
References: <1240193547.25532.52.camel@falcon>
	 <20090420050419.GA22520@adriano.hkcable.com.hk>
	 <1240211926.8884.27.camel@falcon> <20090420080155.GA11621@linux-mips.org>
	 <20090420131022.GA10183@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 20 Apr 2009 22:22:03 +0800
Message-Id: <1240237323.8884.42.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 15:10 +0200, Ralf Baechle wrote:
> On Mon, Apr 20, 2009 at 10:01:55AM +0200, Ralf Baechle wrote:
> 
> > > I have divided ftrace to several commits in the above git tree, hope you
> > > can check it, thx :-) 
> > > 
> > > in addition to the static/dynamic/graph function tracer & system call
> > > tracer implementation, a mips specific ring_buffer_time_stamp
> > > (kernel/trace/ring_buffer.c) is also implemented to get 1us precision
> > > time, this is very important to make ftrace available in mips,
> > > otherwise, we can only get 1ms precision time for the original
> > > ring_buffer_time_stamp is based on sched_clock(jiffies based). 
> > > 
> > > perhaps we can implement a more precise sched_clock directly, just as
> > > x86 does(native_sched_clock, tsc based), but in mips, there is only a
> > > 32bit timer count which will quickly overflow, so it will need an extra
> > > overflow protection, which may influence the other parts of the kernel.
> > 
> > My git clone is still running to I'm commenting only on the patches you
> > posted earlier.  #ifdef-MIPS'ing things into the generic kernel code
> > definately won't be an acceptable way to get µs resolution.
> 

just fix it via moving mips specific ring_buffer_time_stamp to
arch/mips/kernel/ftrace.c via defining the original one as
__attribute__(weak).

in arch/mips/kernel/ftrace.c: 

u64 native_ring_buffer_time_stamp(...) {
...
}
u64 ring_buffer_time_stamp(...)
__attribute__((alias("native_ring_buffer_time_stamp")));

in kernel/trace/ring_buffer.c:

-u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+ u64 __attribute__((weak)) ring_buffer_time_stamp(struct ring_buffer
*buffer, int cpu)

*** not push to the git tree yet.

> In changeset e67f78d663a84ef93aa12c3c8c1adf3033c4f9a1 you introduce
> <asm/rwsem.h> but because RWSEM_GENERIC_SPINLOCK is always set that file
> won't ever be included.
> 

Yes, currently, I'm trying to fix it.

>   Ralf

