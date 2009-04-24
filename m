Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZDXP5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZDXP5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZDXP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:57:24 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:49151 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZDXP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:57:23 -0400
Date: Fri, 24 Apr 2009 21:27:10 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090424155710.GA5008@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090424055637.GA7909@in.ibm.com> <Pine.LNX.4.44L0.0904240959460.2894-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904240959460.2894-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 10:16:07AM -0400, Alan Stern wrote:
> On Fri, 24 Apr 2009, K.Prasad wrote:
> 
> > The arch_update_kernel_hw_breakpoints() was designed to work like this -
> > it updates all registers beginning 'hbp_kernel_pos' to (HB_NUM - 1) with
> > the values stored in hbp_kernel[] array.
> > 
> > When inserting a new breakpoint, hbp_kernel_pos is decremented *before*
> > invoking arch_update_kernel_hw_breakpoints() so that the new value is
> > also written onto the physical debug register.
> > 
> > On removal, 'hbp_kernel_pos' is incremented *after*
> > arch_update_kernel_hw_breakpoints() so that the physical debug registers
> > i.e. both DR7 and DR<pos> are updated with the changes post removal and
> > compaction. I'm ready to make changes but don't see where the code
> > actually goes wrong. Can you explain that?
> 
> I'm sorry; I misread the code in arch_update_kernel_hw_breakpoints().  
> It isn't actually wrong, and you are correct to increment
> hbp_kernel_pos where you do.  Your code is different from my original
> version, which would update all the debug registers at once instead of
> doing the kernel and userspace breakpoints separately -- that's what 
> confused me.
> 
> There is one change you could make to improve the routine, however.  In 
> arch_update_kernel_hw_breakpoints(), the line
> 
> 	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
> 
> really should be
> 
> 	kdr7 = 0;
> 
> since kdr7 never contains anything other than kernel breakpoint
> settings.  (You could update the comment in the preceding line as
> well.)
> 
> Alan Stern

Sure, I'd make that change (in the subsequent iteration) - it's much simpler.

Do you think that the patchset is now in a form that can be submitted
for upstream (-tip tree) acceptance?

Thanks,
K.Prasad

