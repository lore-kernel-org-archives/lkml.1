Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0CHS2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0CHS2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:28:47 -0500
Date: Mon, 8 Mar 2010 19:27:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, sivanich@sgi.com, torvalds@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, dipankar@in.ibm.com,
       josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
Message-ID: <20100308182708.GA8504@redhat.com>
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268063603-7425-3-git-send-email-tj@kernel.org> <20100308171020.GC2557@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308171020.GC2557@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Heiko Carstens wrote:
>
> On Tue, Mar 09, 2010 at 12:53:21AM +0900, Tejun Heo wrote:
> >
> > diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
> > index 65065ac..afe429e 100644
> > --- a/arch/s390/kernel/time.c
> > +++ b/arch/s390/kernel/time.c
> > @@ -397,7 +397,6 @@ static void __init time_init_wq(void)
> >  	if (time_sync_wq)
> >  		return;
> >  	time_sync_wq = create_singlethread_workqueue("timesync");
> > -	stop_machine_create();
> >  }
> >
> >  /*
>
> The reason we introduced stop_machine_create/destroy was to have a non-failing
> variant that doesn't rely on I/O.
> If we ever see a timesync machine check no I/O will succeed (it blocks) until
> clocks have been synchronized. That means also that we rely on the non-blocking
> semantics that those functions must have that are called via stop_machine.
> This isn't true anymore with the cpu hog infrastructure:
> if passed a blocking function that could wait on I/O we won't see any progress
> anymore and the machine is dead.

Could you please spell?

How cpuhog can make a difference? Afaics, we shouldn't pass a blocking callback
to hog_cpus/hog_one_cpu.

Oleg.

