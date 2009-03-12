Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZCLXsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZCLXsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZCLXry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:47:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48680 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZCLXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:47:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] ring-buffer: only allocate buffers for online cpus
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0903120933400.3062@gandalf.stny.rr.com>
References: <20090312162722.43B1.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903120933400.3062@gandalf.stny.rr.com>
Message-Id: <20090313083919.43CB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 08:47:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't like this patch.
> > your [1/4] and [2/4] already solve Pierre's problem.
> > 
> > using online cpu (not possible cpu) increase performance overhead 
> > and messiness.
> > but nobody get benefit ;)
> 
> Well, the fact that you can have 15 buffers for non existent CPUs is a big 
> benefit. And the overhead was only on the read side, not the write, and 
> very limited in overhead for that matter.
> 
> But, looking at this, I realized I can get rid of all the 
> "get_online_cpus". I originally had the CPU_DOWN_PREPARE remove the 
> buffer. But I found it highly annoying during tests, that I lose my data 
> when I brought down a CPU. Thus, I removed the code to free the buffer and 
> replaced it with the comment explaining this.
> 
> The get_online_cpus is to prevent the race where we might remove a buffer. 
> But since we do not do that anymore, those get_online_cpus are pretty 
> useless.
> 
> I'll update the code in a bit.

Great!

from mission critical area view, CPU down event is very important.
I don't hope to lost trace data of downed cpu.
and no get_online_cpus() don't cause annoy overhead.

I love to see your next patch :)


