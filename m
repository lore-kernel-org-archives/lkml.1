Return-Path: <linux-kernel-owner+w=401wt.eu-S1767268AbXDTV3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767268AbXDTV3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767271AbXDTV3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:29:09 -0400
Received: from mail.screens.ru ([213.234.233.54]:60099 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767268AbXDTV3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:29:08 -0400
Date: Sat, 21 Apr 2007 01:28:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       ebiederm@xmission.com, containers@lists.osdl.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream
Message-ID: <20070420212835.GA863@tv-sign.ru>
References: <20070420.015838.83621529.davem@davemloft.net> <29341.1176975158@redhat.com> <2969.1176992303@redhat.com> <1101.1177056127@redhat.com> <4713.1177065706@redhat.com> <20070420113805.c4877dc8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420113805.c4877dc8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Andrew Morton wrote:
>
> On Fri, 20 Apr 2007 11:41:46 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > There are only two non-net patches that AF_RXRPC depends on:
> > 
> >  (1) The key facility changes.  That's all my code anyway, and shouldn't be a
> >      problem to merge unless someone else has put some changes in there that I
> >      don't know about.
> > 
> >  (2) try_to_cancel_delayed_work().  I suppose I could use
> >      cancel_delayed_work() instead, but that's less efficient as it waits for
> >      the timer completion function to finish.
> 
> There are significant workqueue changes in -mm and I plan to send them
> in for 2.6.22.  I doubt if there's anything in there which directly
> affects cancel_delayed_work(), but making changes of this nature against
> 2.6.21 might lead to grief.

I think it is better to use cancel_delayed_work(), but change it to use
del_timer(). I belive cancel_delayed_work() doesn't need del_timer_sync().

We only care when del_timer() returns true. In that case, if the timer
function still runs (possible for single-threaded wqs), it has already
passed __queue_work().

Oleg.

