Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZDFD5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZDFD5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 23:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDFD5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 23:57:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37488 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZDFD5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 23:57:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: + mm-align-vmstat_works-timer.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       anton@samba.org, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090406120533.450B.A69D9226@jp.fujitsu.com>
References: <200904011945.n31JjWqG028114@imap1.linux-foundation.org> <20090406120533.450B.A69D9226@jp.fujitsu.com>
Message-Id: <20090406125627.4514.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon,  6 Apr 2009 12:57:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (swich to lkml and linux-mm)
> 
> Hi Anton,
> 
> Do you have any mesurement data?
> 
> Honestly, I made the same patch few week ago.
> but I found two problems.
> 
> 1)
> work queue tracer (in -tip) reported it isn't proper rounded.

Ah, sorry ignore this sentence.
I used my local patch queue's feature for mesurement, not -tip.


> 
> The fact is, schedule_delayed_work(work, round_jiffies_relative()) is
> a bit ill.
> 
> it mean
>   - round_jiffies_relative() calculate rounded-time - jiffies
>   - schedule_delayed_work() calculate argument + jiffies
> 
> it assume no jiffies change at above two place. IOW it assume
> non preempt kernel.
> 
> 
> 2)
> > -	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
> > +	schedule_delayed_work_on(cpu, vmstat_work,
> > +				 __round_jiffies_relative(HZ, cpu));
> 
> isn't same meaning.
> 
> vmstat_work mean to move per-cpu stastics to global stastics.
> Then, (HZ + cpu) mean to avoid to touch the same global variable at the same time.
> 
> Oh well, this patch have performance regression risk on _very_ big server.
> (perhaps, only sgi?)
> 
> but I agree vmstat_work is one of most work queue heavy user.
> For power consumption view, it isn't proper behavior.
> 
> I still think improving another way.


