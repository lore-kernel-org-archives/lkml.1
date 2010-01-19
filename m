Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437Ab0ASIhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0ASIhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600Ab0ASIhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:37:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:33893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0ASIhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:37:50 -0500
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <4B5505E2.4080203@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-5-git-send-email-tj@kernel.org>
	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org>
	 <1263814869.4283.296.camel@laptop>  <4B5505E2.4080203@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:37:02 +0100
Message-ID: <1263890222.4283.634.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 10:07 +0900, Tejun Heo wrote:
> 
> It's also necessary to guarantee forward progress during CPU_DOWN.
> The problem with kthread_bind() is that it's not synchronized against
> CPU hotplug operations.  It needs outer synchronization like calling
> it directly from CPU_DOWN_PREP.  I guess it's doable but I think it
> would be better to simply share the backend implementation between
> set_cpus_allowed_ptr() and kthread_bind().

OK, so you're saying you need to migrate the rescue thread during
cpu-down. That thread is guaranteed sleeping right, if it were not it'd
not be elegible to run on our dying cpu. Hence kthread_bind() ought to
just work, no?

