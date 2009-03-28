Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZC1IrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZC1IrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 04:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZC1IrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 04:47:06 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34744 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZC1IrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 04:47:03 -0400
Date: Sat, 28 Mar 2009 14:16:48 +0530
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
Message-ID: <20090328084647.GB5297@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090324152435.GA17918@in.ibm.com> <Pine.LNX.4.44L0.0903251547150.21443-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903251547150.21443-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:48:31PM -0400, Alan Stern wrote:
> > +
> > +/*
> > + * Handle debug exception notifications.
> > + */
> > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > +{
> > +	int i, rc = NOTIFY_DONE;
> > +	struct hw_breakpoint *bp;
> > +	/* The DR6 value is stored in args->err */
> > +	unsigned long dr7, dr6 = args->err;
> 
> Please change this.  (I should have changed it long ago, but I never
> got around to it.)  Instead of passing the DR6 value in args->err,
> pass a pointer to the dr6 variable in do_debug().  That way the
> handler routines can turn off bits in that variable and do_debug() can
> see which bits remain set at the end.
> 
> Of course, this will require a corresponding change to the
> post_kprobe_handler() routine.
>

As I looked at the code with an intention of changing it, I don't find a
place - in hw_breakpoint_handler() and in functions called by
kprobe_exceptions_notify() where bits in dr6 are written into.
The thread-specific thread->debugreg6 is updated with causative bits in
ptrace_triggered() to help send signals to the user-space. I don't see a
user for the change you propose.

I should send out the revised patchset sometime tomorrow. Kindly let me
know your comments about them.

Thanks,
K.Prasad

