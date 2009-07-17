Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZGQUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZGQUyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZGQUyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:54:43 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:40753 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbZGQUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:54:42 -0400
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
From: Nathan Lynch <ntl@pobox.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Nigel Cunningham <nigel@tuxonice.net>, stable@kernel.org,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Matt Helsley <matthltc@us.ibm.com>
In-Reply-To: <20090717122103.225652146@linutronix.de>
References: <20090717121545.489258927@linutronix.de>
 <20090717122103.225652146@linutronix.de>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 15:54:25 -0500
Message-Id: <1247864065.17553.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 0BFCD506-7314-11DE-A2D9-F699A5B33865-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 12:25 +0000, Thomas Gleixner wrote:
> commit e3c8ca8336 (sched: do not count frozen tasks toward load) broke
> the nr_uninterruptible accounting on freeze/thaw. On freeze the task
> is excluded from accounting with a check for (task->flags &
> PF_FROZEN), but that flag is cleared before the task is thawed. So
> while we prevent that the freezing task with state
> TASK_UNINTERRUPTIBLE is accounted to nr_uninterruptible we decrement
> nr_uninterruptible on thaw.
> 
> Use a separate flag which is handled by the freezing task itself. Set
> it before calling the scheduler with TASK_UNINTERRUPTIBLE state and
> clear it after we return from frozen state.

Thanks for the fix, and sorry for the regression.  I'll test this early
next week but I don't anticipate any problems for the use case the
original patch was addressing.


