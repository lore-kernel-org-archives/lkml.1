Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYLJIo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYLJIo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 03:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYLJIor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 03:44:47 -0500
Received: from aun.it.uu.se ([130.238.12.36]:44638 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYLJIoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 03:44:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18751.33074.432802.639068@harpo.it.uu.se>
Date: Wed, 10 Dec 2008 09:43:30 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>, andi@firstfloor.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
In-Reply-To: <20081210034824.GA27217@linux-sh.org>
References: <20081205.002701.172921476.davem@davemloft.net>
	<20081205084233.GE2030@elte.hu>
	<87ej0mx0c0.fsf@basil.nowhere.org>
	<20081205.120814.51226316.davem@davemloft.net>
	<20081210034824.GA27217@linux-sh.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt writes:
 > The sh perf counters were not designed with overflowing in mind, they are
 > split in to a pair of 48-bit or 64-bit counters that simply keep running.
 > Any write simply clears the value and the counter starts over. They are
 > simply counters only, and generate no events whatsoever.
 > 
 > Oprofile has been a pretty bad fit for them, and while I'm slightly more
 > optimistic about perfmon, I'm rather less enthusiastic about yet another
 > peformance counter implementation that I am unable to make any use of. 

My 'perfctr' kernel extension has supported this type of hardware
since its beginning in 1999, simply because that's how much hardware
worked at the time. Typical CPUs in that category include Intel P5s,
Intel P6s where the local APIC isn't available (some don't have one
in HW, many have it disabled by BIOS), 1st gen AMD K7, VIA C3, early
UltraSPARCs (not supported by perfctr but could be), and many G3/G4
type 32-bit PowerPCs where HW errata make the PMU overflow interrupt
facility useless or dangerous.

Plain event counting over a group of counters is a convenient way of
computing metrics for isolated blocks of code, such as CPI, branch
misses / insn or clock, and such, so I often use that even on CPUs
that do support overflow interrupts.
