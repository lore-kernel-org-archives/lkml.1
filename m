Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZGXMNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZGXMNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 08:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZGXMNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 08:13:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZGXMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 08:13:04 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Jul 2009 14:14:30 +0200
Message-Id: <1248437670.6987.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 18:57 +0800, sen wang wrote:
> I find something is wrong about sched_rt.
> 
>  when I am debugging my system with rt_bandwidth_enabled, there is a
> running realtime FIFO task in the sched_rt running queue and
>  the fair running queue is empty.  I found the idle task will be
> scheduled up when the running task still lie in the  sched_rt running
> queue!
> 
> this will happen when rt runqueue passed it's rt_bandwidth_enabled
> runtime,then the scheduler choose the idle task instead of realtime
> FIFO task.
> 
> the reason lie in: when scheduler try to pick up a realtime FIFO task,
> it will check if rt_throttled is enabled,
> if so, it'll return and try fair queue but it is empty, then it come
> to the sched_idle class.
> 
> I don't think it reasonable, we should give the realtime FIFO task the
> chance, even when rt runqueue passed it's runtime.
> because it is cpu's free time.
> 
> To fix it ,and keep rt_bandwidth works as before, I think
> pick_next_task_rt() is the best space,

RT is about determinism, sometimes having some extra time dependent on
the runnability of SCHED_OTHER tasks is utterly useless.

If you don't like the throttle, disable it.


