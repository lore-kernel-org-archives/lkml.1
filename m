Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXCPOEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXCPOEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964815AbXCPOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:04:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51570 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964807AbXCPOEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:04:06 -0400
Date: Fri, 16 Mar 2007 15:07:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org,
       dhowells@redhat.com
Subject: Re: [PATCH 3/5] AF_RXRPC: Make it possible to merely try to cancel
 timers and delayed work [try #2]
Message-ID: <20070316150705.0b2fbeb0@lxorguk.ukuu.org.uk>
In-Reply-To: <20070316125026.3740.56876.stgit@warthog.cambridge.redhat.com>
References: <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
	<20070316125026.3740.56876.stgit@warthog.cambridge.redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * try_to_cancel_delayed_work - Try to kill pending scheduled, delayed work
> + * @work: the work to cancel
> + *
> + * Try to kill off a pending schedule_delayed_work().
> + * - The timer may still be running afterwards, and if so, the work may still
> + *   be pending
> + * - Returns -1 if timer still active, 1 if timer removed, 0 if not scheduled
> + * - Can be called from the work routine; if it's still pending, just return
> + *   and it'll be called again.
> + */
> +static inline int try_to_cancel_delayed_work(struct delayed_work *work)
> +{
> +	int ret;

This expands to a fair bit of code and IMHO isn't an inline candidate.

