Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbXE3Vw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbXE3Vw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761402AbXE3Vvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:51:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761393AbXE3Vvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:51:36 -0400
Date: Wed, 30 May 2007 14:51:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-soft-lockup-when-removing-netconsole-module.patch added
 to -mm tree
Message-Id: <20070530145123.fe5cb196.akpm@linux-foundation.org>
In-Reply-To: <20070530210137.GA225@tv-sign.ru>
References: <20070530210137.GA225@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 01:01:37 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Jason Wessel wrote:
> >
> > The netpoll_cleanup handler can hang the kernel if there is no work in the
> > work queue because a call to cancel_rearming_delayed_work() with no work
> > goes into an infinite loop.
> 
> This should not be true any longer, cancel_rearming_delayed_work() should work
> correctly in any case.
> 
> Could you please clarify?

We need a 2.6.21.x fix.

> > @@ -771,30 +771,32 @@ void netpoll_cleanup(struct netpoll *np)
> >
> > [...snip...]
> >
> > +		if (atomic_dec_and_test(&npinfo->refcnt)) {
> > +			skb_queue_purge(&npinfo->arp_tx);
> > +			skb_queue_purge(&npinfo->txq);
> > +			if (delayed_work_pending(&npinfo->tx_work)) {
> >  				cancel_rearming_delayed_work(&npinfo->tx_work);
> >  				flush_scheduled_work();
> 
> But this "if (delayed_work_pending())" is racy anyway?
> 

I guess so, a bit.
