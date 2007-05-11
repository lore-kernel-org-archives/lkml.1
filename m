Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbXEKW56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbXEKW56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXEKW5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:57:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074AbXEKW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:57:50 -0400
Date: Fri, 11 May 2007 15:56:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
In-Reply-To: <200705112240.54304.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl>
 <20070511123959.190adfaf.akpm@linux-foundation.org>
 <200705112240.54304.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> 
> For user space processes this condition is always true.
> 
> For kernel threads:
> (1) the change of tsk->mm from NULL to a nonzero value is only made in
> fs/aio.c:use_mm() along with the setting of PF_BORROWED_MM under
> the task_lock(),
> (2) the change of tsk->mm from a nonzero value to NULL is only made in
> fs/aio.c:unuse_mm() along with the resetting of PF_BORROWED_MM
> under the task_lock().
> Therefore, by taking the task_lock() here we make sure that the condition
> is alyways false when we check it for kernel threads.

Why *test* it then and return anything?

Why not just doa "task_lock(p); task_unlock(p);" with no return value? 

As it is, it sounds like either the code is buggy, or it's pointless.

		Linus
