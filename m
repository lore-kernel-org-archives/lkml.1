Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZBCU3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZBCU3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZBCU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:28:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZBCU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:28:57 -0500
Date: Tue, 3 Feb 2009 12:28:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mingo@elte.hu, davem@davemloft.net
Subject: Re: [patch 2/6] epoll keyed wakeups v2 - introduce new *_poll()
 wakeup macros
In-Reply-To: <20090203121041.23d440be.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0902031219520.3247@localhost.localdomain>
References: <send-serie.davidel@xmailserver.org.13601.1233518664.2> <20090203001401.cc960d4e.akpm@linux-foundation.org> <alpine.DEB.1.10.0902031011380.23050@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0902031116500.23050@alien.or.mcafeemobile.com>
 <20090203121041.23d440be.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Andrew Morton wrote:
> > 
> > Actually reading the comments helps :) It triggers an include-hell, if you 
> > make them inline. Since they're lockdep debug thingies, I think it's kinda 
> > wasted turn them into non-inline real functions, so they'd better remain 
> > macros IMO.
> 
> ho hum.  I think it'd be worth at least renaming the arguments to
> something less daft, for readability reasons.

Also, maybe we can make it an out-of-line thing rather than an inline?

Why not just make it

	extern void wake_up_nested[_poll](wait_queue_head_t *,
		[unsigned long pollflags, ] unsigned int nesting);

and then just move it out of a header file entirely by writing it as a 
real function in some *.c file that only gets compiled with 
DEBUG_LOCK_ALLOC.

Hmm? No include hell.

			Linus
