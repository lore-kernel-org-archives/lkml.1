Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZIKH6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZIKH6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZIKH6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:58:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:39549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZIKH6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:58:11 -0400
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4AAA01F4.3050502@cn.fujitsu.com>
References: <20090910192153.GA584@redhat.com>
	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com>
	 <1252654410.7126.1.camel@laptop>  <4AAA01F4.3050502@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:57:52 +0200
Message-Id: <1252655872.7126.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 15:53 +0800, Lai Jiangshan wrote:
> Peter Zijlstra wrote:
> > On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
> >> One other minor thing:
> >> Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
> >> spinlock in RT is also mutex. Likely I'm wrong.
> > 
> > But they have priority-inheritance, hence you cannot create a deadlock
> > through preemption. If the kstopmachine thread blocks on a mutex, the
> > owner gets boosted to kstopmachine's prio and runs to completion, after
> > that kstopmachine continues.
> > 
> 
> The deadlock is because the owner is at the dead cpu, It's not because
> the owner's prio is low. priority-inheritance can't help it.
> 
> I think we need to use a raw spinlock.

Not in mainline you don't.

