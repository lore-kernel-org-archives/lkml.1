Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYFEQPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYFEQPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYFEQO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:14:57 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43814 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYFEQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:14:57 -0400
Date: Thu, 5 Jun 2008 20:16:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: TASK_WAKEKILL && /sbin/init (was: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race)
Message-ID: <20080605161612.GB323@tv-sign.ru>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org> <20080605152316.GA257@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605152316.GA257@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Oleg Nesterov wrote:
>
> Anyway. How about the (untested/uncompiled) patch for now? -EINTR or
> -ERESTARTNOINTR looks "more correct" regardless.
> 
> Oleg.
> 
> --- mm/filemap.c
> +++ mm/filemap.c
> @@ -188,7 +188,7 @@ static int sync_page(void *word)
>  static int sync_page_killable(void *word)
>  {
>  	sync_page(word);
> -	return fatal_signal_pending(current) ? -EINTR : 0;
> +	return fatal_signal_pending(current) ? -ERESTARTNOINTR : 0;

Forgot to mention, this part is questionable of course. And it can't
prevent the case when "ret = sys_read(count)" succeeds, but ret < count.

Oleg.

