Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXJWQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXJWQ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXJWQ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:29:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46688 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbXJWQ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:29:12 -0400
Date: Tue, 23 Oct 2007 22:11:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Message-ID: <20071023164124.GA4666@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4523.4040509@google.com> <20071023024036.GC3324@linux.vnet.ibm.com> <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 11:06:54PM -0700, Paul Menage wrote:
> > > +     for_each_possible_cpu(i) {
> > > +             unsigned long flags;
> > > +             spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);
> >
> > Is the lock absolutely required here?
> 
> I'm not sure, I was hoping you or Ingo could comment on this. But some
> kind of locking seems to required at least on 32-bit platforms, since
> sum_exec_runtime is a 64-bit number.

I tend to agree abt 32-bit platforms requiring a lock to read the 64-bit
sum_exec_runtime field.

Ingo/Dmitry, what do you think? fs/proc/array.c:task_utime() is also
buggy in that case.

-- 
Regards,
vatsa
