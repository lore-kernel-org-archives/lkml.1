Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZK0CMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZK0CMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZK0CMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:12:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:33712 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbZK0CMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:12:52 -0500
Message-ID: <4B0F356B.3040206@kernel.org>
Date: Fri, 27 Nov 2009 11:11:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>	 <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org>	 <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org>	 <20091126095154.GE32275@elte.hu> <4B0E5458.30303@kernel.org>	 <20091126102936.GA1196@elte.hu> <1259231565.4273.31.camel@twins>	 <1259234619.4273.32.camel@twins>  <20091126115605.GA15189@elte.hu> <1259239259.4273.82.camel@twins>
In-Reply-To: <1259239259.4273.82.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter, Ingo.

11/26/2009 09:40 PM, Peter Zijlstra wrote:
> CALLBACK_EVENT() would be my preferred name, and shouldn't live anywhere
> near the regular tracing bits, the tracing bits could simply add another
> callback in it when enabled.

I haven't looked at the mm code but if the scheduler callback
requirement isn't gonna explode big time soon and we know which
functions are the candidate callbacks at build time, I think this can
be done pretty efficiently with an ulong enable mask per task and
fixed function dispatch such that no callback case just goes through
one likely() conditional test at the tracing point and callback cases
are dispatched using conditional direct jump.

The thing is that I've been sitting on these workqueue patches for
months now and I really want them in stable tree at this point.  So,
how about putting the current simplistic notifier code into a sched/
branch which is not pushed to Linus and then after pushing the
workqueue patches, I'll work on the notifiers branch before pushing
the whole thing to Linus.  Although the scheduler notifier changes
necessary for c-m-workqueue adds more notifiers, it's just extension
of an existing facility and pretty isolated change from other
workqueue changes.

How does that sound?

Thanks.

-- 
tejun
