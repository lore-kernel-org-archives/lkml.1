Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZAWLHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZAWLHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760979AbZAWLHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:07:36 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41912 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760673AbZAWLHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:07:35 -0500
Date: Fri, 23 Jan 2009 16:37:20 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, richardj_moore@uk.ibm.com, naren@linux.vnet.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces - v4
Message-ID: <20090123110720.GA22751@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090122135640.GA11161@in.ibm.com> <Pine.LNX.4.44L0.0901221032220.2417-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0901221032220.2417-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 10:42:48AM -0500, Alan Stern wrote:
> On Thu, 22 Jan 2009, K.Prasad wrote:
> 
> > Hi All,
> > 	Please find the new set of patches that introduce kernel
> > interfaces to use Hardware Breakpoint registers and an implementation
> > for x86 (and x86_64) architecture, now labelled as Version IV.
> > 
> > The patches are based on 2.6.29-rc2 and have been tested to work fine on
> > x86 architecture. Some of the major changes over the previous version of
> > patches include:
> > i) A sample kernel module that uses Data Hardware breakpoint over a
> > kernel variable to monitor write operations. See
> > samples/hw_breakpoint/data_breakpoint.c.
> > ii) Changes in the register_kernel_hw_breakpoint() interface to accept
> > only one parameter - pointer to a 'hw_breakpoint' structure which will
> > contain all relevant data members.
> 
> I see some problems with this immediately.  Firstly, as a result of
> this change the sample code in include/asm-generic/hw_breakpoint.h is
> now incorrect.  You need to change the comments when you change the
> code.
> 
> Second, your arch_store_info() routine is broken.  It checks for a
> kernel symbol name even if when a userspace breakpoint is being
> registered.  You should move that check up into validate_settings().
> 
> As a related matter, why did you put the "name" field into the
> arch-dependent part?  Clearly it should be arch-independent.
> 
> Alan Stern
> 

The user-space breakpoint requests face an issue due to removal of
HW_BREAKPOINT_EXECUTE support, since ptrace was made to service these
requests through the __register_user_hw_breakpoint() interface.

Through offline discussions, the suggestion gathered was to let ptrace
process these requests for instruction watchpoint while maintaining a
coherent view on the number of available registers.

I will send out a patch that refactors ptrace to handle instruction
watchpoint requests (until we get it to support through our interface),
which should also contain changes to the corresponding comments and
'name' field.

Thanks,
K.Prasad



