Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYJQKdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYJQKdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYJQKcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:32:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYJQKcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:32:54 -0400
Subject: Re: [PATCH] sched: fix the wrong mask_len
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: miaox@cn.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081017192505.E242.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <48F8664A.2000205@cn.fujitsu.com>
	 <20081017192505.E242.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 12:33:04 +0200
Message-Id: <1224239584.28131.85.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 19:25 +0900, KOSAKI Motohiro wrote:
> > If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
> > domains by catting /proc/schedstat. This is caused by the wrong mask_len.
> > 
> > This patch fix it.
> > 
> > Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> > 
> > ---
> >  kernel/sched_stats.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> > index 8385d43..81365b3 100644
> > --- a/kernel/sched_stats.h
> > +++ b/kernel/sched_stats.h
> > @@ -9,7 +9,7 @@
> >  static int show_schedstat(struct seq_file *seq, void *v)
> >  {
> >  	int cpu;
> > -	int mask_len = NR_CPUS/32 * 9;
> > +	int mask_len = (NR_CPUS/32 + 1) * 9;
> >  	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
> >  
> 
> DIV_ROUND_UP() is better?

Agreed

