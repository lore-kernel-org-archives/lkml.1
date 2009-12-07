Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbZLGKfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbZLGKfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZLGKfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:35:46 -0500
Received: from www.tglx.de ([62.245.132.106]:59626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZLGKfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:35:45 -0500
Date: Mon, 7 Dec 2009 11:35:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: When it is save to kfree() hrtimer object?
In-Reply-To: <200912071045.09827@blacky.localdomain>
Message-ID: <alpine.LFD.2.00.0912071127440.3089@localhost.localdomain>
References: <200912071045.09827@blacky.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Nikita V. Youshchenko wrote:
> - Isn't it a bug that timer object is accessed after it's callback was 
> called and returned HRTIMER_NORESTART?

No, it's not. It's deliberately implemented that way.

> - If that is not a bug, then when it is "officially safe" to deallocate 
> struct hrtimer object?

When it's neither enqueued nor running the callback. See the other use
sites.
 
> - Are there any recommendations on how to implement "single-shot" timers 
> like in my case?

Well, you wake up something which waits on completion of that request,
right ? Probably the caller which issued the request. Why don't you
free the request in the waiter context after it got woken up ?

Thanks,

	tglx
