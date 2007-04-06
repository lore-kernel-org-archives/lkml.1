Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXDFTsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXDFTsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXDFTsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:48:10 -0400
Received: from mail.screens.ru ([213.234.233.54]:41503 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXDFTsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:48:09 -0400
Date: Fri, 6 Apr 2007 23:47:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406194756.GB96@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406193621.GA96@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406193621.GA96@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Oleg Nesterov wrote:
>
> --- t/kernel/exit.c~	2007-04-06 23:31:31.000000000 +0400
> +++ t/kernel/exit.c	2007-04-06 23:31:57.000000000 +0400
> @@ -275,10 +275,7 @@ static void reparent_to_init(void)
>  	remove_parent(current);
>  	current->parent = child_reaper(current);
>  	current->real_parent = child_reaper(current);

Just noticed. Eric, is it ok we are using child_reaper() here?
This is for kernel threads only, shouldn't we always use
init_pid_ns.child_reaper ? (yes, it is the same currently).

Oleg.

