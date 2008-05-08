Return-Path: <linux-kernel-owner+w=401wt.eu-S1762728AbYEHLBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728AbYEHLBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYEHLBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:01:40 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:59474 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYEHLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:01:39 -0400
Message-ID: <4822DD4E.3010000@googlemail.com>
Date: Thu, 08 May 2008 13:00:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
References: <48222C7C.2050807@googlemail.com> <20080507154155.2b472bb1.akpm@linux-foundation.org> <482233CD.70502@googlemail.com>
In-Reply-To: <482233CD.70502@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 May 2008 10:53:39.0036 (UTC) FILETIME=[C5B4B9C0:01C8B0F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Andrew Morton wrote:
>> On Thu, 08 May 2008 00:26:04 +0200
>> Gabriel C <nix.or.die@googlemail.com> wrote:
>>
>>> Hi all,
>>>
>>> I've updated today to 2.6.26-rc1-00166-gc0a1811 , running an 64bit kernel at the moment.
>> Which kernel were you runing previously?
> 
> 2.6.25* , tested 2.6.25-git* , 2.6.26-rc1 , and 2.6.26-rc1-00065-g5717922.
> 
> 
>>From my log 2.6.26-rc1-00065-g5717922 was fine.
> 
> ...
>  
> May  6 00:13:14 thor kernel: [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
> May  6 00:13:14 thor kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> May  6 00:13:14 thor kernel: [    0.000000] PERCPU: Allocating 41732 bytes of per cpu data
> May  6 00:13:14 thor kernel: [    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
> May  6 00:13:14 thor kernel: [    0.000000] Preemptible RCU implementation.
> May  6 00:13:14 thor kernel: [    0.000000] Extended CMOS year: 2000
> May  6 00:13:14 thor kernel: [    0.000000] TSC calibrated against PM_TIMER
> May  6 00:13:14 thor kernel: [    0.000014] time.c: Detected 2499.952 MHz processor.
> May  6 00:13:14 thor kernel: [    0.000032] console [tty0] enabled
> May  6 00:13:14 thor kernel: [    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> May  6 00:13:14 thor kernel: [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> May  6 00:13:14 thor kernel: [    0.000999] Checking aperture...
> 
> ...
> 
>>> dmesg shows here :
>>>
>>> ...
>>>
>>>
>>> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
>>> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
>>> [    0.000000] PERCPU: Allocating 42756 bytes of per cpu data
>>> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
>>> [4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010753
>>> [4294014.506571] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
>>> [4294014.506571] Initializing CPU#0
>>> [4294014.506571] Preemptible RCU implementation.
>>> [4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes) 
>>>
>>> ...                                                                                     
>>>
>>>
>>> Is this a known issue ?
>>>
>> Not to me.
>>
> 

I've bisected it.

git bisect log
git-bisect start
 # good: [2ddcca36c8bcfa251724fe342c8327451988be0d] Linux 2.6.26-rc1
 git-bisect good 2ddcca36c8bcfa251724fe342c8327451988be0d
 # bad: [3de2403e6659d71b36ec820dc9b942762ddfe6eb] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6
 git-bisect bad 3de2403e6659d71b36ec820dc9b942762ddfe6eb
 # bad: [aac6abca858386438d9a7233c3471d2ecfa2f704] sched: default to n for GROUP_SCHED and FAIR_GROUP_SCHED
 git-bisect bad aac6abca858386438d9a7233c3471d2ecfa2f704
 # good: [45ea2103d8856454503b30464cc1dba378748d00] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes
 git-bisect good 45ea2103d8856454503b30464cc1dba378748d00
 # good: [5717922a1b8cc477f45a0f4f11fe619392ba7133] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb
 git-bisect good 5717922a1b8cc477f45a0f4f11fe619392ba7133
 # good: [b328ca182f01c2a04b85e0ee8a410720b104fbcc] sched: fix hrtick_start_fair and CPU-Hotplug
 git-bisect good b328ca182f01c2a04b85e0ee8a410720b104fbcc
 # good: [712555ee4f873515612f89554ad1a3fda5fa887e] sched: fix missing locking in sched_domains code
 git-bisect good 712555ee4f873515612f89554ad1a3fda5fa887e
 # good: [dfbf4a1bc319f0f9a31e39b2da1fa5c55e85af89] sched: fix cpu clock
 git-bisect good dfbf4a1bc319f0f9a31e39b2da1fa5c55e85af89
 # bad: [3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd] sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 git-bisect bad 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
 # good: [a5574cf65b5f03ce9ade3918764fe22e5e2371e3] sched, x86: add HAVE_UNSTABLE_SCHED_CLOCK
 git-bisect good a5574cf65b5f03ce9ade3918764fe22e5e2371e3

cat ./.git/refs/bisect/bad
3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd

 git show 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
 commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
 Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 Date:   Sat May 3 18:29:28 2008 +0200
 
     sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
     this replaces the rq->clock stuff (and possibly cpu_clock()).
 
      - architectures that have an 'imperfect' hardware clock can set
        CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
      - the 'jiffie' window might be superfulous when we update tick_gtod
        before the __update_sched_clock() call in sched_clock_tick()
 
      - cpu_clock() might be implemented as:
 
          sched_clock_cpu(smp_processor_id())
 
        if the accuracy proves good enough - how far can TSC drift in a
        single jiffie when considering the filtering and idle hooks?
 
     [ mingo@elte.hu: various fixes and cleanups ]
 
     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
                                                                                                                                                             


Gabriel
