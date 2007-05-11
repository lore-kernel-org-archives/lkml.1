Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbXEKXdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbXEKXdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEKXdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:33:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096AbXEKXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:33:42 -0400
Date: Fri, 11 May 2007 16:32:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
In-Reply-To: <20070511232024.GA489@tv-sign.ru>
Message-ID: <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl>
 <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl>
 <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
 <20070511232024.GA489@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Oleg Nesterov wrote:
> 
> without task_lock() we can see "p->mm != NULL" but not PF_BORROWED_MM.

Let me explain it one more time:
 - shouldn't the *caller* protect this?

Afaik, there's two situations:
 - either things don't change (in which case you don't need locking at 
   all, since things are statically one way or the other)
 - or things change (in which case the caller can't rely on the return 
   value anyway, since they might change *after* you release the lock)
ie what's up? Is there a third case?

		Linus
