Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbYFFQP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbYFFQP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765228AbYFFQOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:14:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765213AbYFFQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:14:08 -0400
Message-ID: <484961FC.5030800@zytor.com>
Date: Fri, 06 Jun 2008 09:12:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       minyard@acm.org, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
References: <20080606152134.GA13641@linux.vnet.ibm.com>
In-Reply-To: <20080606152134.GA13641@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

In theory, recoverable #MC's can occur anywhere.  It's an exception.

> 2.	Does the IPMI subsystem make use of RCU read-side primitives
> 	from within SMI handlers?  If so, we need the SMI handlers to
> 	invoke rcu_irq_enter() upon entry and rcu_irq_exit() upon exit
> 	when they are invoked from dynticks idle state.  Or something
> 	similar, depending on restrictions on code within SMI handlers.

Not sure about that one.  I clearly need to look carefully into this... 
SMI is quite "special" in that it sets up an entirely new environment; 
the concept of executing kernel code at SMI level makes me want to run 
away and hide.

	-hpa

