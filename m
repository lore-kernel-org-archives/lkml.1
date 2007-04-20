Return-Path: <linux-kernel-owner+w=401wt.eu-S2993289AbXDTRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993289AbXDTRXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993294AbXDTRXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:23:47 -0400
Received: from mail.screens.ru ([213.234.233.54]:44746 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993289AbXDTRXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:23:46 -0400
Date: Fri, 20 Apr 2007 21:23:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] workqueue: cancel_rearming_delayed_work/workqueue usage warning
Message-ID: <20070420172348.GC470@tv-sign.ru>
References: <20070419065404.GB1782@ff.dom.local> <20070419144618.GG32602149@melbourne.sgi.com> <20070420081325.GB1695@ff.dom.local> <20070420085354.GP32602149@melbourne.sgi.com> <20070420102157.GD1695@ff.dom.local> <20070420110119.GS32602149@melbourne.sgi.com> <20070420121255.GA4042@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420121255.GA4042@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Jarek Poplawski wrote:
> 
> Here is my proposal to make things clearer:
> (this time on 2.6.21-rc7)
> 
> CC: David Chinner <dgc@sgi.com>
> CC: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> 
> ---
> 
> diff -Nurp 2.6.21-rc7-/kernel/workqueue.c 2.6.21-rc7/kernel/workqueue.c
> --- 2.6.21-rc7-/kernel/workqueue.c	2007-04-18 10:14:16.000000000 +0200
> +++ 2.6.21-rc7/kernel/workqueue.c	2007-04-20 13:56:51.000000000 +0200
> @@ -662,6 +662,8 @@ EXPORT_SYMBOL(flush_scheduled_work);
>   * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
>   * @wq:   the controlling workqueue structure
>   * @dwork: the delayed work struct
> + *
> + * WARNING: use only with handlers, which rearm unconditionally with delay > 0
>   */

Nit: it is ok if the work re-arms itself with delay == 0 "sometimes". What we
need is that the handler use delay > 0 eventually.

I'd suggest to re-diff against -mm tree. I don't think this patch can find its
way to the soon to be released 2.6.21.

Oleg.

