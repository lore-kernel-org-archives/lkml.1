Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZETPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZETPqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZETPqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:46:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZETPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:46:11 -0400
Date: Wed, 20 May 2009 11:42:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
Message-ID: <20090520154241.GC3081@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com> <20090520073348.GA12316@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520073348.GA12316@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 09:33:48AM +0200, Ingo Molnar wrote:
> hm, this is really a compiler bug in essence - the compiler should 
> delay the construction of arguments into unlikely branches - if the 
> arguments are only used there.
> 
> We'd basically open-code a clear-cut:
> 
>    trace_block_bio_complete(md->queue, bio);
>  
> into this form:
> 
>    trace(block_bio_complete, md->queue, bio);
> 
> .. and this latter form could become moot (and a nuisance) if the 
> compiler is fixed.
> 
> Have you tried very latest GCC, does it still have this optimization 
> problem?
> 
> Note that the compiler getting this right would help a _lot_ of 
> other inline functions in the kernel as well. Arguments only used 
> within unlikely() branches are quite common.
> 
> 	Ingo

hi,

I e-mailed the gcc list, where they suggested using a macro, as I've
done. They also suggested filing an enhancement request for this, which
I've done: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=40207 It seems
like they agree with the suggestion. 

It still might make sense to make this requirement explicit (by adding
the extra macro), as the tracepoint off case should really be as optimized as
possible.

thanks,

-Jason
