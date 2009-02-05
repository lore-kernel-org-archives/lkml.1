Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbZBEDbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbZBEDbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZBEDbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:31:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZBEDbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:31:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of ->signal to
	check the task is alive
In-Reply-To: Oleg Nesterov's message of  Wednesday, 4 February 2009 00:17:17 +0100 <20090203231717.GA5028@redhat.com>
References: <20090203231717.GA5028@redhat.com>
X-Windows: power tools for power losers.
Message-Id: <20090205033120.2294BFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 19:31:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It doesn't matter which pointer to check under tasklist to ensure the task
> was not released, ->signal or ->sighand. But we are going to make ->signal
> refcountable, change the code to use ->sighand.

I haven't been following what that's about (signal_struct already has two
atomic counts!).  Uses here protecting cpu_clock_sample_group() e.g., are
around looking at ->signal->foobar, so if ->signal is still there, why not
look at it and be able to get the sample in whatever small window this is?

I don't really understand what this new case might mean though.  Most
things that look at ->signal need to lock it, so access doesn't make any
sense if there is no siglock because ->sighand is clear while ->signal is not.


Thanks,
Roland
