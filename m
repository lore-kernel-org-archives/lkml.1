Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXELO0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXELO0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbXELOZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:25:59 -0400
Received: from mail.screens.ru ([213.234.233.54]:45807 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbXELOZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:25:59 -0400
Date: Sat, 12 May 2007 18:25:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512142558.GB98@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705120201.42619.rjw@sisk.pl> <20070512081622.GA26265@in.ibm.com> <200705121127.37655.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705121127.37655.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Rafael J. Wysocki wrote:
>
> Hmm, I'm not sure if the task can call try_to_freeze() after doing exit().
> May it happen?

It can, note the do_exit()->ptrace_notify(). But this doesn't matter, I think.
>From the freezer POV an exiting task has 2 "interesting" events

	exit_mm()	->mm becomes NULL

	exit_notify()   ->exit_state != 0, and perhaps the task disappears
	                  from global process list

> Or, perhaps, it's better to clear TIF_FREEZE (unconditionally) in exit_mm(),
> after we've done tsk->mm = NULL?  Oleg, what do you think?

Please see another message.

Oleg.

