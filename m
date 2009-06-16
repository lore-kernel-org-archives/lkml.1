Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZFPHOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZFPHOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZFPHO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:14:27 -0400
Received: from www84.your-server.de ([213.133.104.84]:45532 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZFPHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:14:26 -0400
Subject: Re: [patch 2/2] procfs: provide stack information for threads V0.8
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090615150121.ce04ba08.akpm@linux-foundation.org>
References: <1238511505.364.61.camel@matrix>
	 <20090401193135.GA12316@elte.hu> <1244618442.17616.5.camel@wall-e>
	 <20090615150121.ce04ba08.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 09:14:11 +0200
Message-Id: <1245136451.17989.12.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 15.06.2009, 15:01 -0700 schrieb Andrew Morton:
> > ...
> >
> > --- linux-2.6.30.orig/include/linux/sched.h	2009-06-04 09:29:47.000000000 +0200
> > +++ linux-2.6.30/include/linux/sched.h	2009-06-04 09:32:35.000000000 +0200
> > @@ -1429,6 +1429,7 @@
> >  	/* state flags for use by tracers */
> >  	unsigned long trace;
> >  #endif
> > +	unsigned long stack_start;
> >  };
> >  
> 
> A `stack_start' in the task_struct.  This is a bit confusing - we
> already have a `void *stack' in there.  Perhaps this should be named
> user_stack_start or something?
> 
> 
IMHO i think the void *stack is also a to general name, it should be
name kernel_stack or thread_info.

In real we have two stack, so the name user_stack and kernel_stack would
be my favor.

I have examined the source and and task_struct void *stack would be used
in about 10 files.
 


