Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYB1Kjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYB1Kjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYB1Kjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:39:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58554 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYB1Kjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:39:41 -0500
Date: Thu, 28 Feb 2008 19:38:01 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>,
       akpm@linux-foundation.org
In-Reply-To: <20080227071118.GA4638@elte.hu>
References: <20080227103831.423F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080227071118.GA4638@elte.hu>
Message-Id: <20080228192509.BDCF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
CC'ed Steven Rostedt 

I found the following patch cause regression by bisect.

2.6.25-rc2-mm1:                            doesn't boot
2.6.25-rc2-mm1 + revert following patch:   works well

but I think it is very strange.
runqueue_is_locked() seems simple and have not bug. ;)

What do you think this problem?


-------------------------------------------------------------------
commit 033394c2c097215ac556a446154af24fbf18b064
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Feb 25 21:15:44 2008 +0100

    printk: dont wake up klogd with the rq locked

    It is not wise to place a printk where the runqueue lock is held.


> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > hm, that's a bit weird - nothing really should have broken it. Could you 
> > > try to do a specific bisection of sched-devel.git:
> > > 
> > >    http://people.redhat.com/mingo/sched-devel.git/README
> > 
> > How do I know revision of git-sched.patch of 2.6.25-rc2-mm1? Should I 
> > do bisect from HEAD of sched-devel.git?
> 
> yeah, please. If it's caused by sched-devel.git then you should see the 
> hang there too.


