Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbYARCTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbYARCTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYARCTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:19:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbYARCTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:19:42 -0500
Date: Thu, 17 Jan 2008 18:19:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Message-Id: <20080117181935.02294863.akpm@linux-foundation.org>
In-Reply-To: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 10:20:11 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Hello.
> 
> I found the CONFIG_DEBUG_LOCKING_API_SELFTESTS hangs
> at (A-A deadlock)-(wlock) pair.
> 
> 2.6.24-rc8 doesn't hang.
> So, I think the bug is in 2.6.24-rc8-mm1.bz2 .
> 
> The kernel configs are at
> 
>   http://I-love.SAKURA.ne.jp/tmp/config-2.6.24-rc8
>   http://I-love.SAKURA.ne.jp/tmp/config-2.6.24-rc8-mm1
> 

Yes, Zan hit the same bug.

> 
> ---------- 2.6.24-rc8-mm1 ----------
> Linux version 2.6.24-rc8-mm1 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Fri Jan 18 10:13:09 JST 2008
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
>  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
>  BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
>  BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
>  BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
> 0MB HIGHMEM available.
> 512MB LOWMEM available.
> found SMP MP-table at 000f6c90
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   131072
>   HighMem    131072 ->   131072
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   131072
> DMI present.
> Intel MultiProcessor Specification v1.4
>     Virtual Wire compatibility mode.
> OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
> Processor #0 6:15 APIC version 17
> Processor #1 6:15 APIC version 17
> I/O APIC #2 Version 17 at 0xFEC00000.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Processors: 2
> Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
> Kernel command line: root=/dev/sda1 ro noapic nolapic console=ttyS0,115200n8
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> CPU 0 irqstacks, hard=c0523000 soft=c0521000
> PID hash table entries: 2048 (order: 11, 8192 bytes)
> Detected 1993.105 MHz processor.
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:    8
> ... MAX_LOCK_DEPTH:          30
> ... MAX_LOCKDEP_KEYS:        2048
> ... CLASSHASH_SIZE:           1024
> ... MAX_LOCKDEP_ENTRIES:     8192
> ... MAX_LOCKDEP_CHAINS:      16384
> ... CHAINHASH_SIZE:          8192
>  memory used by lock dependency info: 1024 kB
>  per task-struct memory footprint: 1680 bytes
> ------------------------
> | Locking API testsuite:
> ----------------------------------------------------------------------------
>                                  | spin |wlock |rlock |mutex | wsem | rsem |
>   --------------------------------------------------------------------------
>                      A-A deadlock:  ok  |

So does this mean that we got stuck in the first write_lock() test?

I'd be suspecting git-sched, so in lieu of a full bisection search it would
be great if one of you could apply
http://userweb.kernel.org/~akpm/git-sched.patch to 2.6.24-rc8 and see if it
fails in the same way.

