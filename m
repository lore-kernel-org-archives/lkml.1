Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYK0Mu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYK0Mu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYK0MuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:50:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37000 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYK0MuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:50:20 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new function
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <alpine.DEB.1.10.0811261559180.11771@alien.or.mcafeemobile.com>
References: <20081126111511.GE14826@Krystal> <alpine.DEB.1.10.0811261559180.11771@alien.or.mcafeemobile.com>
Message-Id: <20081127134334.3CE1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 27 Nov 2008 21:50:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One of the key design rule of LTTng is to do not depend on such
> > system-wide data structures, or entity (e.g. single manager thread).
> > Everything is per-cpu, and it does scale very well.
> > 
> > I wonder how badly the approach you propose can scale on large NUMA
> > systems, where having to synchronize everything through a single thread
> > might become an important point of contention, just due to the cacheline
> > bouncing and extra scheduler activity involved.
> 
> I dunno the LTT architecture, so I'm staying out of that discussion.
> But, if the patch you're trying to push is to avoid thundering herd of so 
> many threads waiting on the single file*, you've got the same problem 
> right there. You've got at least the spinlock protecting the queue 
> where these threads are focusing, whose cacheline is bounced gets bounced 
> all over the CPUs.
> Do you have any measure of the improvements that such poll_wait_exclusive()
> will eventually lead to?

Also my lttng knowledge isn't perfect.
Then, I'd like to talk about another aspect.

This patch was originally written for memory shortage notification to userland patch.
Currently, many application has own various cache (e.g. almost GUI app
has image cache, the VM of the langueage with GC feature has droppable
garbege memory)

However, To wake up all process makes thundering herd easily.
because it wake up almost process in system.
In addision, any process independent on each other. then, I couldn't 
choice your proposed workaround at that time.

Currently, we and container folks restart to discuss cgroup 
oom notification again.
I think this patch can provide its infrastructure too.

if possible, Could you please don't only review description,
but also the code?



