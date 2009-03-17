Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbZCQSmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbZCQSmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759270AbZCQSmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:42:18 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4707 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbZCQSmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:42:17 -0400
Message-ID: <49BFEF01.1060703@hp.com>
Date: Tue, 17 Mar 2009 14:42:09 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
References: <20090317013220.GA22474@Krystal>
In-Reply-To: <20090317013220.GA22474@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the results for:

processor  : 31
vendor     : GenuineIntel
arch       : IA-64
family     : 32
model      : 0
model name : Dual-Core Intel(R) Itanium(R) 2 Processor 9050
revision   : 7
archrev    : 0
features   : branchlong, 16-byte atomic ops
cpu number : 0
cpu regs   : 4
cpu MHz    : 1598.002
itc MHz    : 400.000000
BogoMIPS   : 3186.68
siblings   : 2
physical id: 196865
core id    : 1
thread id  : 0

test init
test results: time for baseline
number of loops: 20000
total time: 5002
-> baseline takes 0 cycles
test end
test results: time for locked cmpxchg
number of loops: 20000
total time: 60083
-> locked cmpxchg takes 3 cycles
test end
test results: time for non locked cmpxchg
number of loops: 20000
total time: 60002
-> non locked cmpxchg takes 3 cycles
test end
test results: time for locked add return
number of loops: 20000
total time: 155007
-> locked add return takes 7 cycles
test end
test results: time for non locked add return
number of loops: 20000
total time: 155004
-> non locked add return takes 7 cycles
test end
test results: time for enabling interrupts (STI)
number of loops: 20000
total time: 45003
-> enabling interrupts (STI) takes 2 cycles
test end
test results: time for disabling interrupts (CLI)
number of loops: 20000
total time: 59998
-> disabling interrupts (CLI) takes 2 cycles
test end
test results: time for disabling/enabling interrupts (STI/CLI)
number of loops: 20000
total time: 107274
-> enabling/disabling interrupts (STI/CLI) takes 5 cycles
test end

