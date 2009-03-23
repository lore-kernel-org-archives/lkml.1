Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZCWRFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZCWRFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZCWRFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:05:03 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40390 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZCWRFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:05:01 -0400
Date: Mon, 23 Mar 2009 13:04:18 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090323170418.GD4224@zod.rchland.ibm.com>
References: <20090317013220.GA22474@Krystal> <20090318115624.GF3873@zod.rchland.ibm.com> <20090323165632.GC24084@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323165632.GC24084@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 12:56:32PM -0400, Mathieu Desnoyers wrote:
>* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>> On Mon, Mar 16, 2009 at 09:32:20PM -0400, Mathieu Desnoyers wrote:
>> >Hi,
>> >
>> >I am trying to get access to some non-x86 hardware to run some atomic
>> >primitive benchmarks for a paper on LTTng I am preparing. That should be
>> >useful to argue about performance benefit of per-cpu atomic operations
>> >vs interrupt disabling. I would like to run the following benchmark
>> >module on CONFIG_SMP :
>> >
>> >- PowerPC
>> >- MIPS
>> >- ia64
>> >- alpha
>> >
>> >usage :
>> >make
>> >insmod test-cmpxchg-nolock.ko
>> >insmod: error inserting 'test-cmpxchg-nolock.ko': -1 Resource temporarily unavailable
>> >dmesg (see dmesg output)
>> >
>> >If some of you would be kind enough to run my test module provided below
>> >and provide the results of these tests on a recent kernel (2.6.26~2.6.29
>> >should be good) along with their cpuinfo, I would greatly appreciate.
>> >
>> >Here are the CAS results for various Intel-based architectures :
>> >
>> >Architecture         | Speedup                      |      CAS     |         Interrupts         |
>> >                     | (cli + sti) / local cmpxchg  | local | sync | Enable (sti) | Disable (cli)
>> >-------------------------------------------------------------------------------------------------
>> >Intel Pentium 4      | 5.24                         |  25   | 81   | 70           | 61          |
>> >AMD Athlon(tm)64 X2  | 4.57                         |  7    | 17   | 17           | 15          |
>> >Intel Core2          | 6.33                         |  6    | 30   | 20           | 18          |
>> >Intel Xeon E5405     | 5.25                         |  8    | 24   | 20           | 22          |
>> 
>> 
>> I know you have results from a POWER6 machine already, but
>> here are the results on a dual-G5 running 2.6.29-rc7-git4.
>> 
>> If you are interested, I could get you results from running
>> this on an embedded PowerPC board.
>> 
>
>Thanks for the results. Well, those already shows that the tradeoff is
>different between POWER6 and POWER5, so I guess further powerpc numbers
>won't be required.

Correction, a dual-G5 is a PowerPC 970 machine.  It's closer to POWER4
than POWER5 and nothing like POWER6.  The Apple G5 machines are about
2 generations old in terms of 64-bit PowerPC CPUs.

josh
