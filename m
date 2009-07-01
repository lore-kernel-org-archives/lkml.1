Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZGAImp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZGAImp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZGAImh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:42:37 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61556 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZGAImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:42:36 -0400
Date: Wed, 01 Jul 2009 17:42:26 +0900 (JST)
Message-Id: <20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp>
To: andi@firstfloor.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <87hbxwj1k3.fsf@basil.nowhere.org>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp>
	<87hbxwj1k3.fsf@basil.nowhere.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Wed, 01 Jul 2009 09:38:04 +0200

> Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:
> 
> > Hi,
> >
> > I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> > After applied this patch, /proc/<PID>/sched will change like this,
> 
> The problem is that spinlocks are very common and schedstats is enabled commonly
> in production kernels. You would need to demonstrate that such a change doesn't
> have significant performance impact. For me it looks like it has.

I agree with your opinion about performance impact.
I thought this will make no problem,
because schedstat is categorized as "Kernel hacking" section.
But according to you, many production kernels enable it
so my patch will make widespread performance degradation.
I didn't know that, sorry.

> 
> Also I'm not sure exactly what good such a metric is. Do you have 
> a concrete use case?
> 

I want to know about behavior of Apache.
Because Apache uses sendfile() system call,
and according to this paper, sendfile() acquires many spinlocks

http://www.usenix.org/events/vm04/tech/uhlig.html

And spinlocks may cause terrible performance problem when Linux is running on VM.

> The normal way to check for lock contention or lock bouncingis to
> simply profile cycles or time and see if there is a lot of CPU time in
> locks.

According to Ingo's advice, I'll try to add lock counter to perfcounter.
