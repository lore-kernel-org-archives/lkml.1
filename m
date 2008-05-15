Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbYEOXyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbYEOXyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbYEOXyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:54:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbYEOXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:53:59 -0400
Date: Thu, 15 May 2008 16:51:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: hskinnemoen@atmel.com, nurhussein@gmail.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, arjan@infradead.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, kyle@parisc-linux.org, schwidefsky@de.ibm.com
Subject: Re: Taint kernel after WARN_ON(condition) v2
Message-Id: <20080515165134.cb7df5ed.akpm@linux-foundation.org>
In-Reply-To: <20080515040635.GA2164@linux-sh.org>
References: <20080213142740.GA4895@gandalf.middleearth>
	<20080213155520.681e7c06@dhcp-252-066.norway.atmel.com>
	<20080515040635.GA2164@linux-sh.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 13:06:35 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Wed, Feb 13, 2008 at 03:55:20PM +0100, Haavard Skinnemoen wrote:
> > On Wed, 13 Feb 2008 22:27:40 +0800
> > Nur Hussein <nurhussein@gmail.com> wrote:
> > 
> > > This does not work on architectures where WARN_ON has its own definition. 
> > > These archs are:
> > > 	1. s390
> > > 	2. superh
> > > 	3. avr32
> > > 	4. parisc
> > 
> > Hmm. Relying on the generic code in lib/bug.c qualifies as "own
> > definition" these days? I think the patch below should take care of all
> > four...unless I've misunderstood something.
> > 
> > Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > 
> > diff --git a/lib/bug.c b/lib/bug.c
> > index 530f38f..0d67419 100644
> > --- a/lib/bug.c
> > +++ b/lib/bug.c
> > @@ -35,6 +35,7 @@
> >  
> >      Jeremy Fitzhardinge <jeremy@goop.org> 2006
> >   */
> > +#include <linux/kernel.h>
> >  #include <linux/list.h>
> >  #include <linux/module.h>
> >  #include <linux/bug.h>
> > @@ -149,6 +150,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
> >  			       (void *)bugaddr);
> >  
> >  		show_regs(regs);
> > +		add_taint(TAINT_WARN);
> >  		return BUG_TRAP_TYPE_WARN;
> >  	}
> >  
> 
> I was just about to submit the exact same patch, so it looks like this
> slipped through the cracks. Andrew, please apply.

<goes dumpster-diving through lkml history>

> Acked-by: Paul Mundt <lethal@linux-sh.org>

I'd have ducked that one partly because of lack of changelog but mainly
because it didn't look like anyone tested it.

It's hard to see how it could go wrong, but stranger things have
happened.  To me.  Regularly :(


