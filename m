Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYCXSAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYCXSAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYCXR7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:59:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbYCXR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:59:52 -0400
Date: Mon, 24 Mar 2008 10:58:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
In-Reply-To: <20080324122424.671168000@chello.nl>
Message-ID: <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Mar 2008, Peter Zijlstra wrote:
> 
> As to the regression reported by Marcin; what happens is that we invoke
> printk() while holding the xtime lock for writing. printk() will call
> wake_up_klogd() which tries to enqueue klogd on some rq.
> 
> The known deadlock here is calling printk() while holding rq->lock, which
> would then try to recusively lock the rq again when trying to wake klogd.

Ok.

Right now, however, I think that for 2.6.25 I'll just remove the printk. 

And for the long haul, I really don't think the solution is 
"printk_nowakup()", because this is going to happen again when somebody 
doesn't realize the code is called with the rq lock held, and it's going 
to be a bitch to debug.

I just don't think this is maintainable. 

		Linus
