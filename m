Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZKSQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZKSQG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbZKSQG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:06:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61715 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbZKSQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RO4uZMlTvGP7GPeXHGlc39Zkl2ULKwrwV16fbY0OYzxbeybZf+iA15+6kdAHpDRHbZ
         qeOQDbzjodPgaPf2KW7IHOxyr7k6By98j9Dj1U0YrgQc6b3YIJt97/6sStfoQy2UuPSF
         4XHFuy5YuQN69ArdNw8kuA+qj25dazHo9c/2o=
Date: Thu, 19 Nov 2009 17:07:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/2] lockdep: Include recursive read-locks dependencies
	in the tree
Message-ID: <20091119160657.GC4967@nowhere>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com> <1258506398-5151-2-git-send-email-fweisbec@gmail.com> <1258539965.3918.194.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258539965.3918.194.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 11:26:05AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-18 at 02:06 +0100, Frederic Weisbecker wrote:
> > Currently, recursive read locks are checked in two ways:
> > 
> > - walk through the locks held by the current task and check possible
> >   deadlock.
> > 
> > - if the recursive read lock is not already present in the lock held
> >   by the current task, check its dependencies against the tree.
> > 
> > But this recursive read lock will never be added to the tree of
> > dependencies. It means that the following sequence:
> > 
> > A = rwlock (Ar: taken as read recursive, Aw: taken as write)
> > B = normal lock
> > 
> >  Ar -> B
> >  B  -> Aw
> > 
> > won't ever be detected as a lock inversion.
> > This patch fixes it by inserting the recursive read locks into the
> > tree of dependencies and enhancing the circular checks (check the
> > class and the read attribute collision).
> 
> There were some very funny corner cases with IRQ state vs recursive
> locks, I don't seen any of that mentioned here.


Ah right. I forgot these cases... I probably need to do some other checks
in check_usage().

I'll have a look at it.

Thanks.

 
> Bot ego and I poked at it at various times, but neither of us managed to
> actually finish it due to getting distracted with other bits I guess.
> 
> http://programming.kicks-ass.net/kernel-patches/cpu-hotplug/
> 
> http://lkml.org/lkml/2009/5/11/203


