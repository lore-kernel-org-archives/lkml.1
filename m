Return-Path: <linux-kernel-owner+w=401wt.eu-S1030788AbXCTAWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030788AbXCTAWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030784AbXCTAVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:21:49 -0400
Received: from mail.screens.ru ([213.234.233.54]:35426 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030782AbXCTAVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:21:47 -0400
Date: Tue, 20 Mar 2007 03:22:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 2/13] signal/timer/event fds v7 - signalfd core ...
Message-ID: <20070320002205.GA338@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.15249.1174348071.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <send-serie.davidel@xmailserver.org.15249.1174348071.2>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Davide Libenzi wrote:
>
> +static void signalfd_unlock(struct signalfd_ctx *ctx,
> +			    struct signalfd_lockctx *lk)
> +{
> +	unlock_task_sighand(lk->tsk, &lk->flags);
> +}

Again, this is a matter of taste. But I can't understand why signalfd_unlock()
needs "signalfd_ctx *ctx" parameter. If we have "struct signalfd_lockctx *lk",
signalfd_lock() can setup lk->ctx if it is ever needed.

Oleg.

