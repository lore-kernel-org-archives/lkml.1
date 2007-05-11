Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXEKXsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXEKXsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbXEKXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:48:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:55872 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068AbXEKXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:48:20 -0400
Date: Sat, 12 May 2007 03:48:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070511234819.GA508@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl> <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org> <20070511232024.GA489@tv-sign.ru> <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Linus Torvalds wrote:
>
> On Sat, 12 May 2007, Oleg Nesterov wrote:
> > 
> > without task_lock() we can see "p->mm != NULL" but not PF_BORROWED_MM.
> 
> Let me explain it one more time:
>  - shouldn't the *caller* protect this?
>
> Afaik, there's two situations:
>  - either things don't change (in which case you don't need locking at 
>    all, since things are statically one way or the other)
>  - or things change (in which case the caller can't rely on the return 
>    value anyway, since they might change *after* you release the lock)

things change, ->mm is not stable if the kernel thread does use_mm/unuse_mm.

However, the return value == 0 does not change in that particular case,
exactly because is_user_space() takes task_lock().

Oleg.

