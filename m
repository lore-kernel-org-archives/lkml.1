Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbXEKXUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbXEKXUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXEKXU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:20:26 -0400
Received: from mail.screens.ru ([213.234.233.54]:45789 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbXEKXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:20:25 -0400
Date: Sat, 12 May 2007 03:20:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070511232024.GA489@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl> <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Linus Torvalds wrote:
>
> On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > 
> > Therefore, by taking the task_lock() here we make sure that the condition
> > is alyways false when we check it for kernel threads.
> 
> Why *test* it then and return anything?
> 
> Why not just doa "task_lock(p); task_unlock(p);" with no return value? 

because we should not freeze a kernel thread at FREEZER_USER_SPACE stage?

without task_lock() we can see "p->mm != NULL" but not PF_BORROWED_MM.

Oleg.

