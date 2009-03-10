Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZCJPxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZCJPxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZCJPxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:53:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36565 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751999AbZCJPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:53:44 -0400
Date: Tue, 10 Mar 2009 11:53:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 04/11] Introduce virtual debug register in thread_struct
 and wrapper-routines around process related functions
In-Reply-To: <20090310143543.GE3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101151450.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> and why is this:
> 
> > @@ -427,13 +427,9 @@ struct thread_struct {
> >  	unsigned long		ip;
> >  	unsigned long		fs;
> >  	unsigned long		gs;
> > -	/* Hardware debugging registers: */
> > -	unsigned long		debugreg0;
> > -	unsigned long		debugreg1;
> > -	unsigned long		debugreg2;
> > -	unsigned long		debugreg3;
> > -	unsigned long		debugreg6;
> > -	unsigned long		debugreg7;
> > +	/* Hardware breakpoint info */
> > +	unsigned long	vdr6;
> > +	struct thread_hw_breakpoint	*hw_breakpoint_info;
> 
> detached from thread_struct? There's a lot of complications 
> (alloc/free, locking, etc.) from this for no good reason - the 
> hardware-breakpoints info structure is alway per thread and is 
> quite small, so there's no reason not to embedd it directly 
> inside thread_struct.

The only reason for separating it out was to avoid bogging down the 
vast majority of threads which aren't debugged.  If you think the extra 
overhead isn't worth worrying about then the hw-breakpoint info 
structure can be embedded.

Alan Stern

