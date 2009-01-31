Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZAaS26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZAaS26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZAaS2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:28:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50112 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZAaS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xsWVziz5elgJpwG69+FkDcx35e2NVbjOPZ3ycMaoHaGR5ETsL5DFqa1P5pC9uOqaX8
         rOOZ/sy05j0VjOUSO2xL/pzX9R5CnLQdsd2z86IkpIq3o50t0ts0oWhtYuupqnkQdr7e
         niyQYlf8l/5gEzTNCktVlJlqJH6+0YU9arobk=
Date: Sat, 31 Jan 2009 19:28:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090131182843.GD5884@nowhere>
References: <20090127001708.GA4815@nowhere> <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere> <20090131101502.7ce8e7af@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090131101502.7ce8e7af@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 10:15:02AM -0800, Arjan van de Ven wrote:
> On Sat, 31 Jan 2009 19:03:49 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > one thing to look at for work queues that never get work is to see
> > > if they are appropriate for the async function call interface
> > > (the only requirement for that is that they need to cope with
> > > calling inline in exceptional cases)
> > > 
> > 
> > 
> > Hi Arjan,
> > 
> > There is one thing that make it hard to replace workqueues in such
> > cases, there is not guarantee the function will run in user context
> > because of this condition:
> > 
> > if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK)
> > 
> > I wanted to replace kpsmoused with an async function but I want to
> > schedule a slow work that can't be done from irq...
> 
> if there is enough value in having a variant that is guaranteed to
> always run from a thread we could add that. Likely that needs that the 
> caller passes in a bit of memory, but that's not too big a deal.
> If there is only 1 in the entire kernel it might not be worth it,
> but if it's a common pattern then for sure...
> 
> do you have a feeling on how common this is ?
> 


I don't know, most of those I've looked on are not documented about the reason
for a private workqueue. I guess most of them can use the usual kevent.

