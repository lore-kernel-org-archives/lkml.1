Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYGFJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYGFJk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 05:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYGFJks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 05:40:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43013 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYGFJkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 05:40:47 -0400
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
X-Auth-Info: o+lKTsKCUi+6gpu8l6+4UVXrektXcCLn/cdYq+l0jf0=
Message-ID: <48709348.6000101@grandegger.com>
Date: Sun, 06 Jul 2008 11:41:28 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
References: <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2 Jul 2008, Wolfgang Grandegger wrote:
>> I removed all "likely" and "unlikely" macros, but the latencies did not
>> improve. Then I added
>>
>> 	preempt_disable();
>> 	preempt_enable();
>>
>> at the two locations mentioned above, like trace_mark() does,  and
>> disabled CONFIG_RCU_TRACE. That helped to keep the latencies low, and it
>> did for 2.6.25.8-rt7 as well. As I see it, adding preemption points seem
>> to prevent high latencies.
> 
> This to me sounds like we have preempt_enable_noresched someplace that
> shouldn't. In otherwords, we enabled preemption without checking if
> preemption is needed, which is a serious bug in -rt.

Yep, in 2.6.25.8-rt7 trace_mark() is not used any more, maybe for that 
reason. Nevertheless, this "bug" kept the latency on my MPC5200 box low.
I will try with the old tracer to understand what the real cause of the 
high latencies is (with CONFIG_RCU_TRACE disabled).

Wolfgang.
