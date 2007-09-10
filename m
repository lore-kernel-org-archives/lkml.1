Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbXIJNE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbXIJNE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbXIJNES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:04:18 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:43475 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167AbXIJNER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:04:17 -0400
Date: Mon, 10 Sep 2007 15:03:06 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Jonathan Lim <jlim@sgi.com>
Cc: balbir@linux.vnet.ibm.com, akpm@linux-foundation.org (Andrew Morton),
       linux-kernel@vger.kernel.org (Linux Kernel Mailing List),
       jlan@cthulhu.engr.sgi.com (Jay Lan)
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
Message-ID: <20070910150306.3f460863@localhost.localdomain>
In-Reply-To: <200709072337.l87Nbv7j430732@sabah.engr.sgi.com>
References: <46D7C23F.7020509@linux.vnet.ibm.com>
	<200709072337.l87Nbv7j430732@sabah.engr.sgi.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 7 Sep 2007 16:37:57 -0700 (PDT),
Jonathan Lim <jlim@sgi.com> a écrit :

> > Excellent, so can Guillaume change ac_btime to be just
> > tsk->start_time?
> 
> I don't think so.  Current time (xtime) is relative to the epoch;
> uptime and tsk->start_time (jiffies) are both relative to some boot
> time.  So you need to subtract uptime from xtime to get the boot time
> relative to the epoch, then add tsk->start_time.  The result is what
> ac_btime should be set to.
> 
> I think his recent changes are as follows:
> 
> --- a/kernel/tsacct.c   Fri Aug 31 01:42:23 2007 -0700
> +++ b/kernel/tsacct.c   Tue Aug 28 20:35:27 2007 +0200
> ...
> -void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
> +static void fill_wall_times(struct taskstats *stats, struct
> task_struct *task) ...
> -       ts = timespec_sub(uptime, tsk->start_time);
> +       ts = timespec_sub(uptime, task->start_time);
> ...
> -       stats->ac_btime = get_seconds() - ts.tv_sec;
> ...
> +       stats->ac_btime = get_seconds() - ts.tv_sec;
> 
> So really no different from before, which is correct.

Yes, I just tried to make it clearer that the computations were needed
to get a wall time. Otherwise, as CSA seems to start using taskstats,
do my changes make sense for your usage?

Thanks.

-- 
Guillaume
