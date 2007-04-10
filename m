Return-Path: <linux-kernel-owner+w=401wt.eu-S1031067AbXDJQh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031067AbXDJQh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031092AbXDJQh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:37:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:48744 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031067AbXDJQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:37:56 -0400
Date: Tue, 10 Apr 2007 20:37:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>,
       Roland McGrath <roland@redhat.com>, acahalan@gmail.com
Subject: Re: [PATCH] Only send pdeath_signal when getppid changes.
Message-ID: <20070410163714.GA104@tv-sign.ru>
References: <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <20070410133808.GA163@tv-sign.ru> <m1y7l0xns0.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7l0xns0.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Eric W. Biederman wrote:
> 
> So this patch fixes the pdeath_signal behaviour only sending a signal
> when the results of getppid would change.

Don't get me wrong, I personally like this patch very much. However,

A long ago, Albert Cahalan (cc-ed) wrote:
>
> I rely on thread-to-thread pdeath notification for my emulator.
> I also need notification on loss of a thread-group or mm, so I do
> my best to emulate those based on thread-to-thread notification.
>
> ...
>
> The way I use it pdeath_signal:
>
> The parent is one of many tasks within a task group.
> The child is not within that thread group, but shares VM.
> (the child is single threaded, existing only to get the signal)
> For each task in the thread group, there is a child task
> waiting for parent death notification. (there are two other
> tasks sharing VM but not in the task group: one to do
> async memory searching, and one to communicate with
> a user interface for debugging -- like an interactive valgrind)

Oleg.

