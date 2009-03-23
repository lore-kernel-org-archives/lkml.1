Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZCWTWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZCWTWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZCWTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:21:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46104 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754881AbZCWTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:21:52 -0400
Date: Mon, 23 Mar 2009 15:21:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20090323190328.GA23426@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903231514350.3610-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, K.Prasad wrote:

> > > Ok. Will do something like:
> > > return (va <= (TASK_SIZE - (hw_breakpoint_length * word_size)));
> > 
> > What is the purpose of word_size here?  The breakpoint length should be 
> > specified in bytes, not words.
> > 
> > Don't forget that that in arch_check_va_in_kernelspace() you need to 
> > check both for values that are too low and values that are too high 
> > (they overflow and wrap around back to a user address).
> > 
> 
> While I understand the user-space checking using the length of the HW
> Breakpoint, I don't really see how I can check for an upper-bound for
> kernel-space virtual addresses. Most usage in the kernel only checks for
> the address >= TASK_SIZE (while they check for add + len if the length
> of the memory is known). I will be glad to have any suggestions in this
> regard.

Isn't that exactly the check you need to implement?

	addr >= TASK_SIZE && (addr + len) >= TASK_SIZE,

or perhaps better,

	addr >= TASK_SIZE && (addr + len) >= addr.

In this case you _do_ know the length of the breakpoint.

Alan Stern

