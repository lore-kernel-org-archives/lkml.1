Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbXEUI3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbXEUI3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbXEUI3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:29:09 -0400
Received: from holomorphy.com ([66.93.40.71]:46398 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbXEUI3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:29:08 -0400
Date: Mon, 21 May 2007 01:29:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070521082926.GH19966@holomorphy.com>
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 03:27:54PM +0200, Dmitry Adamushko wrote:
> Just an(quick) another idea. Say, the load balancer would consider not
> only p->load_weight but also something like Tw(task) =
> (time_spent_on_runqueue / total_task's_runtime) * some_scale_constant
> as an additional "load" component (OTOH, when a task starts, it takes
> some time for this parameter to become meaningful). I guess, it could
> address the scenarios your have described (but maybe break some others
> as well :) ...
> Any hints on why it's stupid?

I guess I'll take time out from coding to chime in.

cfs should probably consider aggregate lag as opposed to aggregate
weighted load. Mainline's convergence to proper CPU bandwidth
distributions on SMP (e.g. N+1 tasks of equal nice on N cpus) is
incredibly slow and probably also fragile in the presence of arrivals
and departures partly because of this. Tong Li's DWRR repairs the
deficit in mainline by synchronizing epochs or otherwise bounding epoch
dispersion. This doesn't directly translate to cfs. In cfs cpu should
probably try to figure out if its aggregate lag (e.g. via minimax) is
above or below average, and push to or pull from the other half
accordingly.


-- wli
