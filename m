Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbZCQDh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbZCQDh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZCQDhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:37:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbZCQDhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:37:20 -0400
Date: Mon, 16 Mar 2009 20:37:05 -0700 (PDT)
Message-Id: <20090316.203705.218202510.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jwboyer@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090317013220.GA22474@Krystal>
References: <20090317013220.GA22474@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 16 Mar 2009 21:32:20 -0400

> If some of you would be kind enough to run my test module provided below
> and provide the results of these tests on a recent kernel (2.6.26~2.6.29
> should be good) along with their cpuinfo, I would greatly appreciate.

Here's sparc64, but cycles is always computed as zero.

Probably that's because get_cycles() on sparc64 counts system
bus clock cycles, not CPU cycles, and you the loop iteration
isn't expensive enough to get a system clock tick in.

This is a dual UltraSPARC-IIIi at 1.2 GHz

[1052598.484452] test init
[1052598.486230] test results: time for baseline
[1052598.487878] number of loops: 20000
[1052598.489485] total time: 752
[1052598.491061] -> baseline takes 0 cycles
[1052598.492649] test end
[1052598.494874] test results: time for locked cmpxchg
[1052598.496460] number of loops: 20000
[1052598.498005] total time: 7879
[1052598.499521] -> locked cmpxchg takes 0 cycles
[1052598.501060] test end
[1052598.503194] test results: time for non locked cmpxchg
[1052598.504733] number of loops: 20000
[1052598.506213] total time: 7879
[1052598.507722] -> non locked cmpxchg takes 0 cycles
[1052598.509229] test end
[1052598.511347] test results: time for locked add return
[1052598.512821] number of loops: 20000
[1052598.514265] total time: 8254
[1052598.515682] -> locked add return takes 0 cycles
[1052598.517130] test end
[1052598.519427] test results: time for non locked add return
[1052598.520850] number of loops: 20000
[1052598.522230] total time: 11259
[1052598.523561] -> non locked add return takes 0 cycles
[1052598.524939] test end
[1052598.526393] test results: time for enabling interrupts (STI)
[1052598.527767] number of loops: 20000
[1052598.529085] total time: 1877
[1052598.530373] -> enabling interrupts (STI) takes 0 cycles
[1052598.531713] test end
[1052598.533240] test results: time for disabling interrupts (CLI)
[1052598.534594] number of loops: 20000
[1052598.535892] total time: 3189
[1052598.537189] -> disabling interrupts (CLI) takes 0 cycles
[1052598.538551] test end
[1052598.540176] test results: time for disabling/enabling interrupts (STI/CLI)
[1052598.541579] number of loops: 20000
[1052598.542900] total time: 3940
[1052598.544207] -> enabling/disabling interrupts (STI/CLI) takes 0 cycles
[1052598.545595] test end

