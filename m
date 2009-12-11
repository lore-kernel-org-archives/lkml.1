Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZLKVTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZLKVTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731AbZLKVTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:19:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52159 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbZLKVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:19:45 -0500
Date: Fri, 11 Dec 2009 21:19:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, jamie.iles@picochip.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211211923.GC12628@n2100.arm.linux.org.uk>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com> <20091211102316.GB16882@elte.hu> <20091211.023808.233094506.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211.023808.233094506.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 02:38:08AM -0800, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 11 Dec 2009 11:23:16 +0100
> 
> > 
> > * Jamie Iles <jamie.iles@picochip.com> wrote:
> > 
> >> +#ifdef __arm__
> >> +#include "../../arch/arm/include/asm/unistd.h"
> >> +#define rmb()		asm volatile("":::"memory")
> >> +#define cpu_relax()	asm volatile("":::"memory")
> >> +#endif
> > 
> > cpu_relax() looks fine, but rmb() seems not to match the one that can be 
> > found in arch/arm/:
> 
> I think he did it this way so it can compile in the meantime,
> and that doing it right requires runtime cpu detection to
> select which barrier instruction is even available on the
> current ARM cpu.

We provide a way for userspace to be independent of the CPU for these
operations by providing code snippets up in the vector page for userspace
to call.  The kernel places the correct code there according to the CPU
it's built for.

Look for __kuser_memory_barrier in arch/arm/kernel/entry-armv.S
