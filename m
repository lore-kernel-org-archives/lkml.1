Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYJVTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYJVTUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYJVTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:20:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYJVTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:20:27 -0400
Date: Wed, 22 Oct 2008 15:20:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 06/11] ftrace: add ftrace warn on to disable ftrace
In-Reply-To: <20081022121257.9a10513e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810221519350.25759@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185136.489385614@goodmis.org> <20081022121257.9a10513e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Andrew Morton wrote:
> > Index: linux-compile.git/kernel/trace/ftrace.c
> > ===================================================================
> > --- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 13:17:29.000000000 -0400
> > +++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 13:20:11.000000000 -0400
> > @@ -32,6 +32,24 @@
> >  
> >  #include "trace.h"
> >  
> > +#define FTRACE_WARN_ON(cond)			\
> > +	do {					\
> > +		if (unlikely(cond)) {		\
> > +			WARN_ON(1);		\
> > +			ftrace_kill();		\
> > +		}				\
> > +	} while (0)
> 
> This could be coded as
> 
> 	if (WARN_ON(cond))
> 		ftrace_kill();

Ah, I didn't realize that WARN_ON returned the value of the condition.
Will update in v2.

-- Steve

> 
> > +#define FTRACE_WARN_ON_ONCE(cond)		\
> > +	do {					\
> > +		static int once;		\
> > +		if (unlikely(cond) && !once) {	\
> > +			once++;			\
> > +			WARN_ON(1);		\
> > +			ftrace_kill();		\
> > +		}				\
> > +	} while (0)
> 
> 
> 	if (WARN_ON_ONCE(cond))
> 		ftrace_kill();
> 
> 
> 
> 
