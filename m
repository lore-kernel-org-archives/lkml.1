Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbYARBxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbYARBxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbYARBxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:53:46 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:33509 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYARBxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:53:45 -0500
Date: Thu, 17 Jan 2008 20:52:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <alpine.LFD.1.00.0801171724520.2957@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0801172045310.1073@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
 <alpine.LFD.1.00.0801171724520.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jan 2008, Linus Torvalds wrote:

> IOW, I think this should be
>
> 	if (raw_irqs_disabled_flags(flags) && wake_klogd)
> 		wake_up_klogd();
>
> Of course, not all architectures seem to suport that thing (it's currently
> only used by the CONFIG_TRACE_IRQFLAGS config option).
>
> Damn. So close, yet so far away.

Perhaps we can define something like:

#ifdef CONFIG_HAS_RAW_IRQS_DISABLED_FLAGS
# define test_irqs_disabled_flags(flags) raw_irqs_disabled_flags(flags)
#else
# define test_irqs_disabled_flags(flags) \
	({ (void)flags; irqs_disabled();})
#endif

then we could do

	if (test_irqs_disabled_flags(flags) && wake_klogd)
		wake_up_klogd();

Or is this asking too much ;-)

-- Steve

