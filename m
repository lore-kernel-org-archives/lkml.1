Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZKCPQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZKCPQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZKCPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:16:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbZKCPQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:16:23 -0500
Subject: Re: [PATCH -rt] Updates-from-Jon-Masters-for-hwlat_detector.c.patch
From: Jon Masters <jcm@redhat.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Clark Williams <williams@redhat.com>
In-Reply-To: <520f0cf10911021146i136af7bfg370a217185b5154c@mail.gmail.com>
References: <alpine.LFD.2.00.0910230007030.3737@localhost.localdomain>
	 <alpine.LFD.2.00.0911021620580.12138@localhost.localdomain>
	 <520f0cf10911021146i136af7bfg370a217185b5154c@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Tue, 03 Nov 2009 10:17:21 -0500
Message-Id: <1257261441.12638.111.camel@tonnant>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 20:46 +0100, John Kacur wrote:
> On Mon, Nov 2, 2009 at 4:43 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> >> diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
> >> index be6553f..7191e17 100644
> >> --- a/drivers/misc/hwlat_detector.c
> >> +++ b/drivers/misc/hwlat_detector.c
> >> @@ -262,6 +262,8 @@ static int get_sample(void *unused)
> >>               /* Keep a running maximum ever recorded hardware latency */
> >>               if (sample > data.max_sample)
> >>                       data.max_sample = sample;
> >> +
> >> +             wake_up(&data.wq); /* wake up reader(s) */
> >>       }
> >>
> >>       ret = 0;
> >> @@ -299,8 +301,6 @@ static int kthread_fn(void *unused)
> >>                       goto err_out;
> >>               }
> >>
> >> -             wake_up(&data.wq); /* wake up reader(s) */
> >> -
> >
> > This reverts -rt commit 5fc485f6341c177e9d5f641c6fb9e33ca465aa84.
> >
> > CONFIG_DEBUG_SPINLOCK_SLEEP resp. CONFIG_DEBUG_PREEMPT will tell you
> > why this is a bad idea on -rt :)
> >
> > Thanks,
> >
> >        tglx
> > --
> 
> Ugh. Thanks for catching that. To be honest not sure how it happened,
> so it must be my fault. :)
> 
> Updated patch just adds the error checking from Jon Masters then,
> patched against -rt.

Actually, I think it might be my fault. I'll talk to you about the best
way to proceed with updates since we're still looking for a reproducer
on that lockup Clark was seeing a while back.

Jon.


