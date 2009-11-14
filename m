Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZKNTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZKNTqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 14:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZKNTqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 14:46:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:36960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZKNTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 14:46:17 -0500
Subject: Re: perf counters: problem with perf record
From: Peter Zijlstra <peterz@infradead.org>
To: Simon =?ISO-8859-1?Q?K=E4mpflein?= <s.kaempflein@gmx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4AFEE55B.3000906@gmx.de>
References: <4AFEE55B.3000906@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Nov 2009 20:46:20 +0100
Message-ID: <1258227980.30187.512.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 03:14 +1000, Simon Kämpflein wrote:
> Hello,
> 
> I have a problem with the new kernel perf tools in kernel 2.6.31.6 (very
> nice tools by the way). I like to monitor the cache-misses of a program.
> "perf stat -e cache-misses program" works without problems, but I can't
> get "perf record -e cache-misses program" working (even running as root
> and CONFIG_PERF_COUNTERS=y):
> 
> Error: perfcounter syscall returned with -1 (Operation not supported)
> Fatal: No CONFIG_PERF_COUNTERS=y kernel support configured?
> 
> strace of "perf stat":
> SYS_336(0x8508da0, 0x1074, 0xffffffff, 0xffffffff, 0) = 3
> 
> strace of "perf record":
> SYS_336(0x8508da0, 0xf85, 0xffffffff, 0xffffffff, 0) = -1 EOPNOTSUPP
> (Operation not supported)
> 
> My CPU is a "Intel(R) Pentium(R) M processor 1.80GHz":
> [    0.004337] p6 PMU driver.
> [    0.004343] ... version:                 0
> [    0.004345] ... bit width:               32
> [    0.004347] ... generic counters:        2
> [    0.004349] ... value mask:              00000000ffffffff
> [    0.004351] ... max period:              000000007fffffff
> [    0.004353] ... fixed-purpose counters:  0
> [    0.004355] ... counter mask:            0000000000000003

Does the bootlog perchance contain the output of?

        if (!cpu_has_apic) {
                pr_info("no APIC, boot with the \"lapic\" boot parameter
to force-enable it.\n");
                pr_info("no hardware sampling interrupt available.\n");
                x86_pmu.apic = 0;
        }

And does booting with the suggested lapic parameter cure your problems?

