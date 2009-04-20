Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZDTPG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZDTPG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZDTPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:06:17 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:51948 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZDTPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:06:16 -0400
Date: Mon, 20 Apr 2009 15:10:22 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Zhang Le <r0bertz@gentoo.org>, linux-kernel@vger.kernel.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, zhangfx@lemote.com,
       loongson-dev@googlegroups.com, yanh@lemote.com,
       linux-mips@linux-mips.org, linux-rt-users@vger.kernel.org
Subject: Re: "RT_PREEMPT for loongson" is updated to patch-2.6.29.1-rt8
Message-ID: <20090420131022.GA10183@linux-mips.org>
References: <1240193547.25532.52.camel@falcon> <20090420050419.GA22520@adriano.hkcable.com.hk> <1240211926.8884.27.camel@falcon> <20090420080155.GA11621@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090420080155.GA11621@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 10:01:55AM +0200, Ralf Baechle wrote:

> > I have divided ftrace to several commits in the above git tree, hope you
> > can check it, thx :-) 
> > 
> > in addition to the static/dynamic/graph function tracer & system call
> > tracer implementation, a mips specific ring_buffer_time_stamp
> > (kernel/trace/ring_buffer.c) is also implemented to get 1us precision
> > time, this is very important to make ftrace available in mips,
> > otherwise, we can only get 1ms precision time for the original
> > ring_buffer_time_stamp is based on sched_clock(jiffies based). 
> > 
> > perhaps we can implement a more precise sched_clock directly, just as
> > x86 does(native_sched_clock, tsc based), but in mips, there is only a
> > 32bit timer count which will quickly overflow, so it will need an extra
> > overflow protection, which may influence the other parts of the kernel.
> 
> My git clone is still running to I'm commenting only on the patches you
> posted earlier.  #ifdef-MIPS'ing things into the generic kernel code
> definately won't be an acceptable way to get µs resolution.

In changeset e67f78d663a84ef93aa12c3c8c1adf3033c4f9a1 you introduce
<asm/rwsem.h> but because RWSEM_GENERIC_SPINLOCK is always set that file
won't ever be included.

  Ralf
