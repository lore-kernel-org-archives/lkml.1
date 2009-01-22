Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZAVF2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZAVF2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 00:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZAVF2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 00:28:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37879 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZAVF2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 00:28:31 -0500
Date: Thu, 22 Jan 2009 14:27:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, Chris Snook <csnook@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-Id: <20090122142721.34068fdf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200901221043.13684.knikanth@suse.de>
References: <200901211638.23101.knikanth@suse.de>
	<20090122122843.7e94878e.kamezawa.hiroyu@jp.fujitsu.com>
	<200901221043.13684.knikanth@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 10:43:12 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> On Thursday 22 January 2009 08:58:43 KAMEZAWA Hiroyuki wrote:
> > On Wed, 21 Jan 2009 16:38:21 +0530
> >
> > Nikanth Karthikesan <knikanth@suse.de> wrote:
> > > As Alan Cox suggested/wondered in this thread,
> > > http://lkml.org/lkml/2009/1/12/235 , this is a container group based
> > > approach to override the oom killer selection without losing all the
> > > benefits of the current oom killer heuristics and oom_adj interface.
> > >
> > > It adds a tunable oom.victim to the oom cgroup. The oom killer will kill
> > > the process using the usual badness value but only within the cgroup with
> > > the maximum value for oom.victim before killing any process from a cgroup
> > > with a lesser oom.victim number. Oom killing could be disabled by setting
> > > oom.victim=0.
> > >
> > > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > Assume following
> >   - the usar can tell "which process should be killed at first"
> >
> > What is the difference between oom_adj and this cgroup to users ?
> 
> It is next to impossible to specify the order among say 10 memory hogging 
> tasks using oom_adj. Using this oom-controller users can specify the exact 
> order.
> 
> > If oom_adj is hard to use, making it simpler is a good way, I think.
> > rather than adding new complication.
> >
> > It seems both of oom_adj and this cgroup will be hard-to-use functions
> > for usual system administrators. But no better idea than using memcg
> > and committing memory usage.
> >
> 
> To use oom_adj effectively one should continuously monitor oom_score of all 
> the processes, which is a complex moving target and keep on adjusting the 
> oom_adj of many tasks which still cannot guarantee the order. This controller 
> is deterministic and hence easier to use.
> 

Okay, thank you for explanation :)
I think it's better to explain "why this is much easier to use rather
than oom_adj and what is the benefit to users." in your patch description
and to improve your documentation.

+But it is very difficult to suggest an order among tasks to be killed during
+Out Of Memory situation. The OOM Killer controller aids in doing that.

As.
 Difference from oom_adj:
 This allows users to specify "strict order" of oom-kill's select-bad-process
 operation. While oom_adj just works as a hint for the kernel, OOM Killer
 Controller gives users full control.

 In general, it's very hard to specify oom-kill order of several applications
 only by oom_adj because it's just affects "badness" calculation.

A my English skill is poor, you'll be able to write better text ;)

Regards,
-Kame

