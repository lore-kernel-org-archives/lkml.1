Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYJFV20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYJFV20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYJFV2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:28:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60802 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYJFV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:28:18 -0400
Date: Mon, 6 Oct 2008 23:34:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power optimization
Message-ID: <20081006213418.GM3180@one.firstfloor.org>
References: <20081006102640.481acd23@infradead.org> <87y711moz2.fsf@basil.nowhere.org> <20081006135715.6a52e954@infradead.org> <20081006211939.GL3180@one.firstfloor.org> <20081006142131.37104893@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006142131.37104893@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 02:21:31PM -0700, Arjan van de Ven wrote:
> > > the link between P states and frequency is... rather lose.
> > > Especially with Turbo Mode it no longer is really relevant to list
> > > frequencies.
> > 
> > It would probably be less confusing for everyone if the higher level
> > cpufreq layers reported the correct frequency for turbo mode too.
> > I haven't checked how complicated this would be.
> 
> it's impossible until after the fact; you don't know which frequencies
> you got until you check back later.

Well it could do that couldn't it? Ok not sure how big the cost
would be.

I can just imagine Turbo mode becoming a FAQ on this list and having
better reporting upfront might mitigate this a bit.

> 
> 
> > Ok.
> > 
> > That means that when a CPU is idle forever there won't be any output?
> 
> correct; it'll wait until it stops being idle before telling  you how
> long it was idle.
> 
> if it really bothers you we could do a dummy broadcast ipi on shutting
> down the tracer.. in practice it's not a problem.

Or just mark entry/exit, but you just need a wakeup threshold to avoid
the loop. A wakeup threshold seems like a good idea anyways though, just
to get better efficiency on larger systems.

> (we wake up all cpus all the time)

I assume that will change in the future and might even not true
anymore on some special stripped down configurations.

-Andi

-- 
ak@linux.intel.com
