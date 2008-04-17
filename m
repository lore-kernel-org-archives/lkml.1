Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbYDQH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbYDQH0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYDQH0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:26:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYDQH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:26:06 -0400
Date: Thu, 17 Apr 2008 00:25:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417002552.5742ad65.akpm@linux-foundation.org>
In-Reply-To: <20080416202338.GA6007@elte.hu>
References: <20080416202338.GA6007@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> what's brewing in x86.git for v2.6.26?

How much of this has not been in -mm?

How much of this has not been in linux-next?

> too many topics to list them all - there are 884 patches from 74 authors 
> at the moment.
> 
> a few highlights:
> 
>  - 4096 CPUs support. (Yes, such big boxes exist, and they run Linux.)
> 
>  - mmiotrace feature: trace accesses to hw components to help figure out 
>    how they are programmed.
> 
>  - kmemcheck feature: Valgrind for the native Linux kernel in essence - 
>    detects access to uninitialized memory.
> 
>  - ftrace plugin for sysprof

sysprof is crap.

>  - fixed StackProtector security feature (these fixes were too intrusive 
>    for v2.6.25)
> 
>  - lazy FPU allocation/speedup - offloaded/large FPU/SSE state support
> 
>  - SMP-boot, mpparse, DMA ops unification
> 
>  - PAT support - first step towards phasing out MTRR's for cache 
>    attribute control
> 
>  - enable GBPAGES - faster TLB misses on CPUs that support it
> 
>  - debug helper: view kernel pagetable layout via debugfs

Needs documentation.

>       x86: introduce /dev/mem restrictions with a config option

This should be runtime-settable, not build-time settable.

> ...
>
> Randy Dunlap (2):
> ...
>       linux-next: Tree for April 10 (arch/x86)

borked patch title.

> Soren Sandmann (1):
>       x86: add the debugfs interface for the sysprof tool

There were serious objections that this is weaker than and duplicative of
oprofile which were not adequately addressed.

Also, I (and apparently only I) actually reviewed the implementation and
found it to be riddled with bugs and shortcomings.  afacit this was
completely ignored and you propose to merge it anwyay?


I obviously don't have time to go through it all, but I'm afraid I cannot
be very confident in it.  All I can say is "the parts which have been in
-mm seem to compile and run".  A quick grep indicates that only 644 of
these 884 patches are in -mm.  And a lot of them only turned up a week or
two ago.
