Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbXETBl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbXETBl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 21:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbXETBlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 21:41:50 -0400
Received: from omta04ps.mx.bigpond.com ([144.140.83.156]:32842 "EHLO
	omta04ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbXETBlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 21:41:50 -0400
Message-ID: <464FA753.7040206@bigpond.net.au>
Date: Sun, 20 May 2007 11:41:39 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>	 <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au>	 <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com>
In-Reply-To: <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta08ps.mx.bigpond.com from [144.131.192.218] using ID pwil3058@bigpond.net.au at Sun, 20 May 2007 01:41:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 18/05/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
>> [...]
>> One thing that might work is to jitter the load balancing interval a
>> bit.  The reason I say this is that one of the characteristics of top
>> and gkrellm is that they run at a more or less constant interval (and,
>> in this case, X would also be following this pattern as it's doing
>> screen updates for top and gkrellm) and this means that it's possible
>> for the load balancing interval to synchronize with their intervals
>> which in turn causes the observed problem.  A jittered load balancing
>> interval should break the synchronization.  This would certainly be
>> simpler than trying to change the move_task() logic for selecting which
>> tasks to move.
> 
> Just an(quick) another idea. Say, the load balancer would consider not
> only p->load_weight but also something like Tw(task) =
> (time_spent_on_runqueue / total_task's_runtime) * some_scale_constant
> as an additional "load" component (OTOH, when a task starts, it takes
> some time for this parameter to become meaningful). I guess, it could
> address the scenarios your have described (but maybe break some others
> as well :) ...
> Any hints on why it's stupid?

Well that is the kind of thing I was hoping to avoid for the reasons of 
complexity.  I think that the actual implementation would be more 
complex than it sounds and possibly require multiple runs down the list 
of moveable tasks which would be bad for overhead.

Basically, I don't think that the problem is serious enough to warrant a 
complex solution.  But I may be wrong about how complex the 
implementation would be.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
