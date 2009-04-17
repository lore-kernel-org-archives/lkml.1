Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbZDQM5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbZDQM5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZDQM50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:57:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59328 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbZDQM50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:57:26 -0400
Date: Fri, 17 Apr 2009 15:00:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [14/28] x86: MCE: Add MSR read wrappers for easier error injection
Message-ID: <20090417130030.GK14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <20090407150756.23F221D046E@basil.firstfloor.org> <49E866C7.4080707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E866C7.4080707@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 08:23:51PM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> > This will be used by future patches to allow machine check error injection.
> > Right now it's a nop, except for adding some wrappers around the MSR reads.
> > 
> > This is early in the sequence to avoid too many conflicts.
> > 
> > Andi Kleen <ak@linux.intel.com>
> > 
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce_64.c |   37 ++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> > 
> > Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
> > +++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:12.000000000 +0200
> > @@ -171,6 +171,19 @@
> >  	panic(msg);
> >  }
> 
> Since you introduce X86_MCE_INJECT in later patch,
> how about this style?

If someone feels strongly about that I can do that, but personally
I would think using standard function return arguments without
macros is more regular and more readable in general. That seems
to be also the general trend in the source base, going away from
magic macros.

Do you feel strongly about it?

-Andi

> 
> #ifdef CONFIG_X86_MCE_INJECT
> #define mce_rdmsrl(msr,v) (v) = __mce_rdmsrl((msr))
> #define mce_wrmsrl(msr,v) __mce_wrmsrl((msr),(v))
