Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZLWIRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZLWIRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZLWIRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:17:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59031 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZLWIRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vWvMQbAZ6TAoKErnIqj0LZ8a5fz74HhFRxsWRwme9T7pqvryHkdYjxxB4utDIl9yoa
         CRZ54qBbJl058BjYDWtXXgxXx67SrPVJYa2bQRxiprcQn4QwzlUPEO1DzBxeCR7lYQWC
         nbjoXKh1cGZhtD2PVfmt8YHlpyWhw9znKz3ug=
MIME-Version: 1.0
In-Reply-To: <20091222180703.GI10314@basil.fritz.box>
References: <20091221091754.GG4489@kernel.dk>
	 <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
	 <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	 <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>
	 <1261504042.4937.59.camel@laptop>
	 <20091222180703.GI10314@basil.fritz.box>
Date: Wed, 23 Dec 2009 09:17:07 +0100
Message-ID: <c76f371a0912230017n7d3f5c89h849aa23efa6f75e5@mail.gmail.com>
Subject: Re: workqueue thing
From: Stijn Devriendt <highguy@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mi@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 7:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
> One reason I liked a more dynamic frame work for this is that it
> has the potential to be exposed to user space and allow automatic
> work partitioning there based on available cores.  User space
> has a lot more CPU consumption than the kernel.
>
Basically, this is exactly what I was trying to solve with my
sched_wait_block patch. It was broken in all ways, but the ultimate
goal was to have concurrency managed workqueues (to nick the term)
in userspace and have a way out when I/O hits the workqueue.

I'm currently in the progress of implementing this using perf_events
and hope to send a patch in the near future (probably asking for some
help to solve a couple of my issues).

> I think Grand Central Dispatch does something in this direction.
> TBB would probably also benfit
>
Exactly my goal.
I'd definately be happy if Tejun's work can be generalized to fit userspace
as well. My sched_wait_block patch did exactly what his sched_notifiers
do: notify the workqueue that a new thread should be scheduled to keep
the CPU busy. Although as I understand, Tejun's reason for scheduling
a new thread is rather to avoid deadlocks. Different thing, same way.

Stijn
