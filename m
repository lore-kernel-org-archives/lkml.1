Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbXHYPK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbXHYPK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 11:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXHYPKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 11:10:50 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:51236 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729AbXHYPKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 11:10:49 -0400
Date: Sat, 25 Aug 2007 17:10:39 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
Message-ID: <20070825171039.3bc73781@localhost.localdomain>
In-Reply-To: <46C9C8D4.9080108@linux.vnet.ibm.com>
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
 <20070802120427.270e5589.akpm@linux-foundation.org>
 <20070819213435.72b287ad@localhost.localdomain>
 <46C9C8D4.9080108@linux.vnet.ibm.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 20 Aug 2007 22:31:08 +0530,
Balbir Singh <balbir@linux.vnet.ibm.com> a écrit :

> > --- a/kernel/taskstats.c	Sat Aug 18 17:15:17 2007 -0700
> > +++ b/kernel/taskstats.c	Sun Aug 19 17:20:15 2007 +0200
> > @@ -246,6 +246,8 @@ static int fill_tgid(pid_t tgid, struct 
> > 
> >  		stats->nvcsw += tsk->nvcsw;
> >  		stats->nivcsw += tsk->nivcsw;
> > +		bacct_add_tsk(stats, tsk);
> > +		xacct_add_tsk(stats, tsk);
> 
> I'm afraid this is still not good enough. bacct_add_tsk() will assign
> values and do nothing in the loop (HINT: no summation).

Hi Balbir, thank you for your review. I agree with everything you said
and am on my way to do it as time permits, but I have some trouble
understanding this part. You stated that bacct_add_tsk() would overwrite
the stats of each thread in the tgid stats, but the other part of the
patch is the (actually wrong) combination of stats in xxx_add_tsk()
using min/max/sum.

Also, I don't understand why the code to update btime:

        /* calculate task elapsed time in timespec */
        do_posix_clock_monotonic_gettime(&uptime);
        ts = timespec_sub(uptime, tsk->start_time);
	...
        stats->ac_btime = get_seconds() - ts.tv_sec;

does not simply use tsk->start_time or tsk->real_start_time without
comparing it to the current time.

Thanks.

-- 
Guillaume
