Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYHQVfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYHQVfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 17:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYHQVfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 17:35:40 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:37994 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbYHQVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 17:35:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwEACIzqEhMRKxB/2dsb2JhbACBYqs4CYUbgVg
Date: Sun, 17 Aug 2008 17:30:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fair low-latency rwlock v5 (updated benchmarks)
Message-ID: <20080817213036.GA12838@Krystal>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080817191034.GA5258@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:24:48 up 74 days,  2:05,  7 users,  load average: 0.56, 0.54,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some updated benchmarks of the rwlock v5, showing [min,avg,max]
delays in non-contended and contended cases :

The test module is available at :

http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-fair-rwlock.c

** Performance tests

Dual quad-core Xeon 2.0GHz E5405

* Lock contention delays, per context, 60s test

** get_cycles calibration **
get_cycles takes [min,avg,max] 78,79,84 cycles, results calibrated on avg

** Single writer test, no contention **
writer_thread/0 iterations : 964054, lock delay [min,avg,max] 149,157,5933 cycles

** Single reader test, no contention **
reader_thread/0 iterations : 37591763, lock delay [min,avg,max] 59,65,21383 cycles

** Multiple readers test, no contention **
reader_thread/0 iterations : 9062919, lock delay [min,avg,max] 59,921,42593 cycles
reader_thread/1 iterations : 9014846, lock delay [min,avg,max] 59,928,42065 cycles
reader_thread/2 iterations : 9394114, lock delay [min,avg,max] 59,897,46877 cycles
reader_thread/3 iterations : 9459081, lock delay [min,avg,max] 59,896,38207 cycles

** High contention test **
4 thread readers (no delay loop)
2 thread trylock readers (no delay loop)
2 thread writers (10us period)
2 thread trylock writers (10us period)
1 periodical interrupt readers on 7/8 cpus (IPIs).
1 periodical interrupt trylock readers on 7/8 cpus (IPIs).

writer_thread/0 iterations : 2864146, lock delay [min,avg,max] 179,9493,102563 cycles
writer_thread/1 iterations : 2986492, lock delay [min,avg,max] 179,9332,66923 cycles
trylock_writer_thread/0 iterations : 12789892, successful iterations : 3257203
trylock_writer_thread/1 iterations : 12747023, successful iterations : 3268997
reader_thread/0 iterations : 13091562, lock delay [min,avg,max] 59,5806,141053 cycles
reader_thread/1 iterations : 12574027, lock delay [min,avg,max] 59,5706,141839 cycles
reader_thread/2 iterations : 12805706, lock delay [min,avg,max] 59,5738,138725 cycles
reader_thread/3 iterations : 13352731, lock delay [min,avg,max] 59,5606,137585 cycles
trylock_reader_thread/0 iterations : 63135422, successful iterations : 15204229
trylock_reader_thread/1 iterations : 62306024, successful iterations : 15123824
interrupt_reader_thread/0 iterations : 559
interrupt readers on CPU 0, lock delay [min,avg,max] 167,984,16271 cycles
interrupt readers on CPU 1, lock delay [min,avg,max] 179,1185,9125 cycles
interrupt readers on CPU 2, lock delay [min,avg,max] 155,940,8081 cycles
interrupt readers on CPU 3, lock delay [min,avg,max] 83,1158,13355 cycles
interrupt readers on CPU 4, lock delay [min,avg,max] 77,863,6371 cycles
interrupt readers on CPU 5, lock delay [min,avg,max] 173,1169,16331 cycles
interrupt readers on CPU 6, lock delay [min,avg,max] 155,834,8705 cycles
interrupt readers on CPU 7, lock delay [min,avg,max] 173,1159,10115 cycles
trylock_interrupt_reader_thread/0 iterations : 570
trylock interrupt readers on CPU 0, iterations 280, successful iterations : 239
trylock interrupt readers on CPU 1, iterations 590, successful iterations : 538
trylock interrupt readers on CPU 2, iterations 431, successful iterations : 372
trylock interrupt readers on CPU 3, iterations 605, successful iterations : 570
trylock interrupt readers on CPU 4, iterations 659, successful iterations : 570
trylock interrupt readers on CPU 5, iterations 616, successful iterations : 570
trylock interrupt readers on CPU 6, iterations 675, successful iterations : 570
trylock interrupt readers on CPU 7, iterations 597, successful iterations : 561

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
