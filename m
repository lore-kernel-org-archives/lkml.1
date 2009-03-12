Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZCLHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZCLHcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCLHbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:31:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58443 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZCLHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:31:51 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] ring-buffer: only allocate buffers for online cpus
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090312023936.696105567@goodmis.org>
References: <20090312023720.144716747@goodmis.org> <20090312023936.696105567@goodmis.org>
Message-Id: <20090312162722.43B1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 12 Mar 2009 16:31:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: save on memory
> 
> Currently, a ring buffer was allocated for each "possible_cpus". On
> some systems, this is the same as NR_CPUS. Thus, if a system defined
> NR_CPUS = 64 but it only had 1 CPU, we could have possibly 63 useless
> ring buffers taking up space. With a default buffer of 3 megs, this
> could be quite drastic.
> 
> This patch changes the ring buffer code to only allocate ring buffers
> for online CPUs.  If a CPU goes off line, we do not free the buffer.
> This is because the user may still have trace data in that buffer
> that they would like to look at.
> 
> Perhaps in the future we could add code to delete a ring buffer if
> the CPU is offline and the ring buffer becomes empty.

I don't like this patch.
your [1/4] and [2/4] already solve Pierre's problem.

using online cpu (not possible cpu) increase performance overhead 
and messiness.
but nobody get benefit ;)



