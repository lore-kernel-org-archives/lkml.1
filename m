Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442Ab0ARH35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0ARH35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151Ab0ARH35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:29:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:45990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0ARH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:29:56 -0500
Date: Mon, 18 Jan 2010 18:29:46 +1100
From: Nick Piggin <npiggin@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] oom: OOM-Killed process don't invoke pagefault-oom
Message-ID: <20100118072946.GA10052@laptop>
References: <20100114191940.6749.A69D9226@jp.fujitsu.com>
 <20100114130257.GB8381@laptop>
 <20100115085146.6EC0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115085146.6EC0.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 03:21:40PM +0900, KOSAKI Motohiro wrote:
> > Hi,
> > 
> > I don't think this should be required, because the oom killer does not
> > kill a new task if there is already one in memdie state.
> > 
> > If you have any further tweaks to the heuristic (such as a fatal signal
> > pending), then it should probably go in select_bad_process() or
> > somewhere like that.
> 
> I see, I misunderstood. very thanks.

Well, it *might* be a good idea to check for fatal signal pending
similar your patch. Because I think there could be large latency between
the signal and the task moving to exit state if the process is waiting
uninterruptible in the kernel for a while.

But if you do it in select_bad_process() then it would work for all
classes of oom kill.

Thanks,
Nick

