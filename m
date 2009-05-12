Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZELUj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZELUj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZELUjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:39:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51241 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752086AbZELUjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:39:18 -0400
Date: Tue, 12 May 2009 16:39:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint Interfaces
In-Reply-To: <20090512171210.GC6033@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905121633560.17649-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, K.Prasad wrote:

> hmmh...The (un)register_user_<> and __(un)register_user_<> break-up
> looks so modular and am not sure if combining them would be of any
> benefit (and as you might be aware, the compiler can always choose
> to inline though). And doing this might not be helpful if we like to
> virtualise the debug registers (as in the original implementation) in
> the future.

You can keep them separate if you like, but then at least make the "__" 
routines static and remove them from the .h file.

> The __modify_user_hw_breakpoint() had the "__" prefix because it had
> "int pos" as a parameter, although it can be eliminated by adding a loop
> that iterates through the breakpoints of "tsk". If you prefer
> modify_user_hw_breakpoint(), I will introduce the same in
> kernel/hw_breakpoint.c which acts as a wrapper over __modify_user_<> and
> takes the hw_breakpoint_lock.
> 
> Let me know what you think on the above.

Go ahead and introduce modify_user_hw_breakpoint().  Then the spinlock
can become static.


> Ok. Will change the code as suggested. The return values in the above
> implementation will be modified in the second pass here:
> 
> rc = __modify_user_hw_breakpoint(i, tsk, bp);
> 
> I will save the 'rc' value from the first pass in a separate variable
> and use that as the return value. Operations in the second pass (such as
> unregister/modify are not expected to fail).

That's right.

Alan Stern

