Return-Path: <linux-kernel-owner+w=401wt.eu-S965115AbXBYTIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115AbXBYTIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXBYTIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:08:23 -0500
Received: from [212.12.190.62] ([212.12.190.62]:32939 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965115AbXBYTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:08:23 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Sun, 25 Feb 2007 22:11:14 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702252211.14385.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> now look at kevents as the queueing model. It does not queue 'tasks', it
> lets user-space queue requests in essence, in various states. But it's
> still the same conceptual thing: a memory buffer with some state
> associated to it. Yes, it has no legacies, it has no priorities and
> other queueing concepts attached to it ... yet. If kevents got
> mainstream, it would get the same kind of pressure to grow 'more
> advanced' event queueing and event scheduling capabilities.
> Prioritization would be needed, etc.

But it would probably be tuned specifically to its use case, which would mean 
inherently better performance.

> So my fundamental claim is: a kernel thread /is/ our main request
> structure. We've got tons of really good system calls that queue these
> 'requests' around the place and offer functionality around this concept.
> Plus there's a 1.2+ billion lines of Linux userspace code that works
> well with this abstraction - while there's nary a few thousand lines of
> event-based user-space code.

Think of the kernel scheduler as a default fallback scheduler, for procs that 
are randomly queued.  Anytime you can identify a group of procs/threads that 
behave in a similar way, it's almost always best to do specific/private 
scheduling, for performance reasons.

> I also say that you'll likely get kevents outperform threadlets. Maybe
> even significantly so under the right conditions. But i very much
> believe we want to get similar kind of performance out of thread/task
> scheduling, and not introduce a parallel framework to do request
> scheduling the hard way ... just because our task concept and scheduling
> implementation got too fat. For the same reason i didnt really like
> fibrils: they are nice, and Zach's core idea i think nicely survived in
> the syslet/threadlet model too, but they are more limited than true
> threads. So doing that parallel infrastructure, which really just
> implements the same, and is only faster because it skips features, would
> just be hiding the problem with our primary abstraction. Ok?

Ok.  But what you are proposing here is a dynamically plugable scheduler that 
is extensible on top of that.

Sounds Great!


Thanks!

--
Al

