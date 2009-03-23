Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZCWUmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZCWUmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZCWUme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:42:34 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37268 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZCWUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:42:33 -0400
Date: Tue, 24 Mar 2009 02:12:20 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090323204220.GA19602@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090323190328.GA23426@in.ibm.com> <Pine.LNX.4.44L0.0903231514350.3610-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903231514350.3610-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 03:21:49PM -0400, Alan Stern wrote:
> On Tue, 24 Mar 2009, K.Prasad wrote:
> 
> > > > Ok. Will do something like:
> > > > return (va <= (TASK_SIZE - (hw_breakpoint_length * word_size)));
> > > 
> > > What is the purpose of word_size here?  The breakpoint length should be 
> > > specified in bytes, not words.
> > > 
> > > Don't forget that that in arch_check_va_in_kernelspace() you need to 
> > > check both for values that are too low and values that are too high 
> > > (they overflow and wrap around back to a user address).
> > > 
> > 
> > While I understand the user-space checking using the length of the HW
> > Breakpoint, I don't really see how I can check for an upper-bound for
> > kernel-space virtual addresses. Most usage in the kernel only checks for
> > the address >= TASK_SIZE (while they check for add + len if the length
> > of the memory is known). I will be glad to have any suggestions in this
> > regard.
> 
> Isn't that exactly the check you need to implement?
> 
> 	addr >= TASK_SIZE && (addr + len) >= TASK_SIZE,
> 
> or perhaps better,
> 
> 	addr >= TASK_SIZE && (addr + len) >= addr.
> 
> In this case you _do_ know the length of the breakpoint.
> 
> Alan Stern
>

Aren't we just checking if len is a positive number through the above
checks? The validation checks in the patchset should take care of
negative lengths. Or am I missing something?

I thought you wanted the code to check for an upper sane limit for addr
in kernel-space, say something like this:

TASK_SIZE <= addr <= (Upper limit for Kernel Virtual Address)

When I referred to 'len' in my previous mail, it meant the length
of the kernel virtual memory area (which can be used to find the upper
bound).

Thanks,
K.Prasad

