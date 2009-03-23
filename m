Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZCWQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZCWQ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZCWQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:56:38 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51119 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758597AbZCWQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:56:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACNWx0lMQW1W/2dsb2JhbACBUNEHg34G
Date: Mon, 23 Mar 2009 12:56:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090323165632.GC24084@Krystal>
References: <20090317013220.GA22474@Krystal> <20090318115624.GF3873@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090318115624.GF3873@zod.rchland.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:55:00 up 23 days, 13:21,  1 user,  load average: 1.02, 0.72,
	0.67
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
> On Mon, Mar 16, 2009 at 09:32:20PM -0400, Mathieu Desnoyers wrote:
> >Hi,
> >
> >I am trying to get access to some non-x86 hardware to run some atomic
> >primitive benchmarks for a paper on LTTng I am preparing. That should be
> >useful to argue about performance benefit of per-cpu atomic operations
> >vs interrupt disabling. I would like to run the following benchmark
> >module on CONFIG_SMP :
> >
> >- PowerPC
> >- MIPS
> >- ia64
> >- alpha
> >
> >usage :
> >make
> >insmod test-cmpxchg-nolock.ko
> >insmod: error inserting 'test-cmpxchg-nolock.ko': -1 Resource temporarily unavailable
> >dmesg (see dmesg output)
> >
> >If some of you would be kind enough to run my test module provided below
> >and provide the results of these tests on a recent kernel (2.6.26~2.6.29
> >should be good) along with their cpuinfo, I would greatly appreciate.
> >
> >Here are the CAS results for various Intel-based architectures :
> >
> >Architecture         | Speedup                      |      CAS     |         Interrupts         |
> >                     | (cli + sti) / local cmpxchg  | local | sync | Enable (sti) | Disable (cli)
> >-------------------------------------------------------------------------------------------------
> >Intel Pentium 4      | 5.24                         |  25   | 81   | 70           | 61          |
> >AMD Athlon(tm)64 X2  | 4.57                         |  7    | 17   | 17           | 15          |
> >Intel Core2          | 6.33                         |  6    | 30   | 20           | 18          |
> >Intel Xeon E5405     | 5.25                         |  8    | 24   | 20           | 22          |
> 
> 
> I know you have results from a POWER6 machine already, but
> here are the results on a dual-G5 running 2.6.29-rc7-git4.
> 
> If you are interested, I could get you results from running
> this on an embedded PowerPC board.
> 

Thanks for the results. Well, those already shows that the tradeoff is
different between POWER6 and POWER5, so I guess further powerpc numbers
won't be required.

Mathieu

> josh
> 
> test init
> test results: time for baseline
> number of loops: 20000
> total time: 1532
> -> baseline takes 0 cycles
> test end
> test results: time for locked cmpxchg
> number of loops: 20000
> total time: 48052
> -> locked cmpxchg takes 2 cycles
> test end
> test results: time for non locked cmpxchg
> number of loops: 20000
> total time: 29141
> -> non locked cmpxchg takes 1 cycles
> test end
> test results: time for locked add return
> number of loops: 20000
> total time: 44985
> -> locked add return takes 2 cycles
> test end
> test results: time for non locked add return
> number of loops: 20000
> total time: 32400
> -> non locked add return takes 1 cycles
> test end
> test results: time for enabling interrupts (STI)
> number of loops: 20000
> total time: 65579
> -> enabling interrupts (STI) takes 3 cycles
> test end
> test results: time for disabling interrupts (CLI)
> number of loops: 20000
> total time: 29135
> -> disabling interrupts (CLI) takes 1 cycles
> test end
> test results: time for disabling/enabling interrupts (STI/CLI)
> number of loops: 20000
> total time: 173594
> -> enabling/disabling interrupts (STI/CLI) takes 8 cycles
> test end
> [jwboyer@localhost ~]$

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
