Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbYFFUxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbYFFUxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbYFFUxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:53:19 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:50165 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765208AbYFFUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:53:18 -0400
Date: Fri, 06 Jun 2008 15:53:00 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
In-reply-to: <20080606152134.GA13641@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, dvhltc@us.ibm.com, niv@us.ibm.com
Message-id: <4849A3AC.5090107@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080606152134.GA13641@linux.vnet.ibm.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hello!
>
> A couple of questions about the x86 architecture...
>
> 1.	Can recoverable machine-check exceptions occur from within
> 	NMI handlers?  If so, there is a bug in preemptable RCU's
> 	CONFIG_NO_HZ handling that could be fixed by a patch something
> 	like the one shown below (untested, probably does not even
> 	compile).
>
> 2.	Does the IPMI subsystem make use of RCU read-side primitives
> 	from within SMI handlers?  If so, we need the SMI handlers to
> 	invoke rcu_irq_enter() upon entry and rcu_irq_exit() upon exit
> 	when they are invoked from dynticks idle state.  Or something
> 	similar, depending on restrictions on code within SMI handlers.
>   
If you mean the IPMI driver, it does not tie into any SMI.  It 
theoretically could since there's a bit for that in the watchdog timer, 
but there's been no demand and I haven't looked at it.  I guess it would 
be better than an NMI.

If it did tie in, it would most likely just panic to get useful 
information out before the watchdog reset the system.

-corey
