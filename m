Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZCKQjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZCKQjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZCKQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:39:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52823 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751599AbZCKQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:39:34 -0400
Date: Wed, 11 Mar 2009 12:39:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090311125013.GA9547@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903111235100.2692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, K.Prasad wrote:

> The present implementation can be likened to #3 except that the
> uninstalled() callback is invoked (the user-space call through ptrace
> takes a higher priority and evicts the kernel-space requests even now).
> 
> After the task using four debug registers yield the CPU, the
> kernel-space breakpoint requests are 'restored' and installed() is
> called again.

No, that is wrong.  The kernel breakpoints do not get reinstalled until 
the userspace breakpoints are unregistered.  Merely yielding the CPU is 
not sufficient.

> Even if #3 was implemented as described, we would still retain a
> majority of the complexity in balance_kernel_vs_user() to check newer
> tasks with requests for breakpoint registers.

Some complexity is certainly needed, because at all times we need to
know the maximum number of breakpoints requested by any user task.  
The number of kernel breakpoints that can be allocated is limited to 4
minus this number.

Alan Stern

