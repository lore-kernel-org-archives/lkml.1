Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZEIJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZEIJwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZEIJwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:52:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56171 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZEIJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:52:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <1241861925.6316.112.camel@laptop>
References: <20090509182541.8D0F.A69D9226@jp.fujitsu.com> <1241861925.6316.112.camel@laptop>
Message-Id: <20090509185145.3AD2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat,  9 May 2009 18:52:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 2009-05-09 at 18:26 +0900, KOSAKI Motohiro wrote:
> > 
> > Index: b/kernel/sched.c
> > ===================================================================
> > --- a/kernel/sched.c    2009-05-09 16:48:08.000000000 +0900
> > +++ b/kernel/sched.c    2009-05-09 18:16:00.000000000 +0900
> > @@ -824,8 +824,12 @@ static struct file_operations sched_feat
> >         .release        = single_release,
> >  };
> >  
> > +static __read_mostly s32 cpuacct_batch;
> > +
> >  static __init int sched_init_debug(void)
> >  {
> > +       cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > +
> >         debugfs_create_file("sched_features", 0644, NULL, NULL,
> >                         &sched_feat_fops);
> 
> I'm pretty user you can select cpu accounting without SCHED_DEBUG...

Grr, yes, it's idiot ;)
I'll fix it soon.




