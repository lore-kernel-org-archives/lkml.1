Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbXJAHkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbXJAHkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbXJAHkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:40:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbXJAHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:40:38 -0400
Date: Mon, 1 Oct 2007 00:39:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-Id: <20071001003949.d5c9563e.akpm@linux-foundation.org>
In-Reply-To: <4700A649.9020700@qumranet.com>
References: <20070928105345.GC18163@shadowen.org>
	<20071001064448.GA4239@elte.hu>
	<20071001003007.4e90143b.akpm@linux-foundation.org>
	<4700A649.9020700@qumranet.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Oct 2007 09:48:25 +0200 Avi Kivity <avi@qumranet.com> wrote:

> Andrew Morton wrote:
> >> this is actually a false positive - as the debug code constructs a 
> >> printk output _without_ \n. So the script should check whether there's 
> >> any \n in the printk string - if there is none, do not emit a warning. 
> >> (if you implement that then i think it can remain a warning and does not 
> >> need to move to CHECK.)
> >>     
> >
> > Yeah, it does that sometimes.  I don't think it's fixable within the scope
> > of checkpatch.  It needs to check whether some preceding printk which might
> > not even be in the patch has a \n:
> >
> > 	printk(KERN_ERR "foo");
> > 	<100 lines of whatever>
> > +	printk("bar\n");
> >
> > we're screwed...
> >
> >   
> 
> Isn't that broken on SMP (or with preemption) anyway?

Yep.  Or with interrupts...
