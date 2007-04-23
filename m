Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbXDWWYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbXDWWYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXDWWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:24:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:38216 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXDWWYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:24:12 -0400
Date: Tue, 24 Apr 2007 02:23:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-ID: <20070423222358.GA627@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl> <200704222139.27128.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222139.27128.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Rafael J. Wysocki wrote:
> 
> Move all of the freezer-related flags to a separate field in task_struct and
> introduce functions to operate them using set_bit() etc.
>
> [...snip...]
>
> --- linux-2.6.21-rc6-mm1.orig/kernel/fork.c	2007-04-22 19:37:42.000000000 +0200
> +++ linux-2.6.21-rc6-mm1/kernel/fork.c	2007-04-22 20:55:01.000000000 +0200
> @@ -922,7 +922,7 @@ static inline void copy_flags(unsigned l
>  {
>  	unsigned long new_flags = p->flags;
>  
> -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> +	new_flags &= ~PF_SUPERPRIV;
>  	new_flags |= PF_FORKNOEXEC;
>  	new_flags |= PF_STARTING;
>  	p->flags = new_flags;

OK, but you forgot to clear p->freezer_flags on copy_process()->dup_task_struct()
path ?

Oleg.

