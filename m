Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZBCUHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZBCUHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZBCUHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:07:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40594 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695AbZBCUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:07:11 -0500
Date: Tue, 3 Feb 2009 15:07:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 1/10] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20090203172331.GA8300@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0902031459450.2272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, K.Prasad wrote:

> Hi Alan,
> 	After a better understanding about RCU usage in this patch, I'm
> thinking if the list traversals in kernel/hw_breakpoint.c should be
> changed into their RCU equivalent i.e. list_for_each_entry_rcu() instead
> of list_for_each_entry() and list_del_rcu() instead of list_del() -
> given that we are considering the list of thread HW breakpoints
> (thread_bps) and kernel breakpoints (cur_kbpdata) which are also
> accessed from exception-handler contexts.
> 
> I think that with the possibility of parallel execution of
> the 'update' sections which would alter the protected data structures
> (mentioned above) through functions such as - say insert_bp_in_list(),
> balance_kernel_vs_user() and various other routines and the read-side
> critical regions which need to be identified after converting the list
> traversal routines it would be necessary to wrap the code around them
> with rcu_read_(un)lock() routines.

The read-side critical sections don't need to be identified -- I can
tell you exactly what they are.  There is only one, and it is in
switch_to_thread_hw_breakpoint().  If you go look at that routine,
you'll see it already uses list_for_each_entry_rcu().

> What do you think? Is there something grossly incorrect in this
> assessment of locking requirements?

Not in your assessment of locking requirements, only in your 
understanding of where the critical section is.

Alan Stern

