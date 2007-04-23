Return-Path: <linux-kernel-owner+w=401wt.eu-S1030657AbXDWRMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbXDWRMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030735AbXDWRMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:12:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:46243 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030576AbXDWRMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:12:10 -0400
Date: Mon, 23 Apr 2007 21:11:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, ebiederm@xmission.com,
       containers@lists.osdl.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream
Message-ID: <20070423171157.GA205@tv-sign.ru>
References: <20070420212835.GA863@tv-sign.ru> <20070420.015838.83621529.davem@davemloft.net> <29341.1176975158@redhat.com> <2969.1176992303@redhat.com> <1101.1177056127@redhat.com> <4713.1177065706@redhat.com> <20070420113805.c4877dc8.akpm@linux-foundation.org> <1355.1177317176@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355.1177317176@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, David Howells wrote:
> 
> > We only care when del_timer() returns true. In that case, if the timer
> > function still runs (possible for single-threaded wqs), it has already
> > passed __queue_work().
> 
> Why do you assume that?

If del_timer() returns true, the timer was pending. This means it was started
by work->func() (note that __run_timers() clears timer_pending() before calling
timer->function). This in turn means that delayed_work_timer_fn() has already
called __queue_work(dwork), otherwise work->func() has no chance to run.

When del_timer() returns true and delayed_work_timer_fn() doesn't run we are
safe, this doesn't differ from del_timer_sync().

Oleg.

