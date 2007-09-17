Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbXIQXln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbXIQXln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 19:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXIQXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 19:41:32 -0400
Received: from mail.ccur.com ([66.10.65.12]:27583 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbXIQXlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 19:41:31 -0400
Message-ID: <46EF10A2.40905@ccur.com>
Date: Mon, 17 Sep 2007 19:41:22 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and ib_umad_close()
 issue
References: <46EEB715.7060509@ccur.com> <adair69nf7r.fsf@cisco.com>
In-Reply-To: <adair69nf7r.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2007 23:42:04.0150 (UTC) FILETIME=[59D55160:01C7F984]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Thanks for the explanation...
> 
>  > But basically, with CONFIG_PREEMPT_RT enabled, the lock points, such as
>  > aqcuiring a spinlock, potentially become places where the current task
>  > may be context switched out / preempted.
>  > 
>  > Therefore, when a call is made to lock a spinlock for example, the
>  > caller should not currently have irqs disabled, or preemption disabled,
>  > since a context switch may occur.
> 
> this doesn't seem relevant here...

Hi Roland,

right.  just some background info.

>  > void fastcall rt_downgrade_write(struct rw_semaphore *rwsem)
>  > {
>  >         BUG();
>  > }
> 
> this seems to be the problem... the -rt patch turns downgrade_write()
> into a BUG().
> 
> I need to look at the locking in user_mad.c again, but I think it may
> be possible to replace both places that do downgrade_write() with
> up_write() followed by down_read().
> 
>  - R.


that sounds like it would be a good solution for both preempt rt and 
non-preempt rt kernels.

thanks again for looking at this for us.
