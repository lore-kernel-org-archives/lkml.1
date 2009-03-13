Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZCMOE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZCMOE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZCMOEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:04:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751794AbZCMOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:04:47 -0400
Date: Fri, 13 Mar 2009 10:04:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, <prasad@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090313034301.GE11355@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903130959400.2898-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009, Ingo Molnar wrote:

> The core issue being discussed is the debug register allocation 
> and scheduling model though, and you have not directly commented 
> on that.
> 
> My argument in a nutshell is that a bottom-up for user + 
> top-down for kernel use static allocator with no dynamic 
> scheduling will get us most of the benefits with a tenth of the 
> complexity.

Take this even farther: We shouldn't restrict userspace to bottom-up
register allocation.  With very little additional effort we can
virtualize the debug registers; then userspace can allocate them in
whatever order it wants and still end up using the physical registers
in bottom-up order (or top-down, which is the order used by the current
patches).

After all, there's nothing to prevent programs other than gdb from 
using ptrace, and there's no guarantee that gdb will continue to 
allocate registers in increasing order.

Alan Stern

