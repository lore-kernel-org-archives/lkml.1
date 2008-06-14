Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYFNPMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYFNPMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 11:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYFNPLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 11:11:54 -0400
Received: from [194.117.236.238] ([194.117.236.238]:46444 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbYFNPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 11:11:53 -0400
Date: Sat, 14 Jun 2008 18:11:03 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080614181103.17617db1@linux360.ro>
In-Reply-To: <1213417601.8237.37.camel@charm-linux>
References: <20080613040958.4f52ee29@linux360.ro>
	<1213417601.8237.37.camel@charm-linux>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 23:26:41 -0500
Tom Zanussi <tzanussi@gmail.com> wrote:

> Alternatively, you could get rid of the problem by making sure CPU0
> never reads CPU1's data, by having the userspace reader use per-cpu
> threads and using sched_setaffinity() to pin each thread to a given
> cpu. See for example, the blktrace code, which does this.

Yes, and performance-wise this is better. Though I'm not sure setting
affinity is 100% safe. Will the thread be migrated soon enough, so we
don't read cross-CPU? The point is I'm not sure how hard this is
enforced.

However, I suggest this patch should go in, for two reasons:
1. It provides expected behavior in any such situation.
2. It adds (almost) no overhead when used in conjuction with setting CPU
affinity. When the writer acquires the spinlock, it does not busy-wait,
so the spinlock just disables IRQs (relay_write()).
 
> Actually, in a few days or so I'm planning on releasing the first cut
> of a library that makes this and all the rest of the nice blktrace
> userspace code available to other tracing applications, not just
> blktrace.  Hopefully it would be something that you'd be able to use
> for kmemtrace as well; in that case, you'd just use the library and
> not have to worry about these details.

Sounds good. Thanks for letting me know.


	Eduard
