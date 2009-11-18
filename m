Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZKRK0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZKRK0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbZKRK0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:26:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:54407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbZKRK0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:26:08 -0500
Subject: Re: [PATCH 1/2] lockdep: Include recursive read-locks dependencies
 in the tree
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1258506398-5151-2-git-send-email-fweisbec@gmail.com>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
	 <1258506398-5151-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 11:26:05 +0100
Message-ID: <1258539965.3918.194.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 02:06 +0100, Frederic Weisbecker wrote:
> Currently, recursive read locks are checked in two ways:
> 
> - walk through the locks held by the current task and check possible
>   deadlock.
> 
> - if the recursive read lock is not already present in the lock held
>   by the current task, check its dependencies against the tree.
> 
> But this recursive read lock will never be added to the tree of
> dependencies. It means that the following sequence:
> 
> A = rwlock (Ar: taken as read recursive, Aw: taken as write)
> B = normal lock
> 
>  Ar -> B
>  B  -> Aw
> 
> won't ever be detected as a lock inversion.
> This patch fixes it by inserting the recursive read locks into the
> tree of dependencies and enhancing the circular checks (check the
> class and the read attribute collision).

There were some very funny corner cases with IRQ state vs recursive
locks, I don't seen any of that mentioned here.

Bot ego and I poked at it at various times, but neither of us managed to
actually finish it due to getting distracted with other bits I guess.

http://programming.kicks-ass.net/kernel-patches/cpu-hotplug/

http://lkml.org/lkml/2009/5/11/203



