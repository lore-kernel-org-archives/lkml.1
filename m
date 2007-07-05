Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbXGEPfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbXGEPfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXGEPff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:35:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:34749 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbXGEPfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:35:34 -0400
Date: Thu, 5 Jul 2007 19:36:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] workqueue: debug work related deadlocks with lockdep
Message-ID: <20070705153648.GA236@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net> <20070705110820.622888000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705110820.622888000@sipsolutions.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05, Johannes Berg wrote:
>
> +#define __WORK_INIT_LOCKDEP_MAP(n, k) \
> +	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(n, k),
> +#else
> +#define __WORK_INIT_LOCKDEP_MAP(n, k)
> +#endif
> +
>  #define __WORK_INITIALIZER(n, f) {				\
>  	.data = WORK_DATA_INIT(),				\
>  	.entry	= { &(n).entry, &(n).entry },			\
>  	.func = (f),						\
> +	__WORK_INIT_LOCKDEP_MAP(#n, &(n))			\

[...snip...]

> +#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
> +	{ .name = (_name), .key = (void *)(_key), }

Hmm... Can't understand, please help!

So, __WORK_INITIALIZER() uses work_struct itself as a "struct lock_class_key" ?
How so?

Oleg.

