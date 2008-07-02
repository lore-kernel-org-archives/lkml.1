Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYGBITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYGBITV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYGBITF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:19:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50213 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbYGBITB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:19:01 -0400
Date: Wed, 2 Jul 2008 09:00:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <20080702090048.2ec99b72@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
	<20080624080744.GL20851@kernel.dk>
	<Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
	<20080625082421.GU20851@kernel.dk>
	<Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
	<20080626070723.GL20851@kernel.dk>
	<Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 00:09:22 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > Right, that wont work of course. Completions are typically done through
> > a softirq, so it is not currently done with hard interrupts disabled.
> 
> I thought, from hardirq - that's what IDE is doing. And they are called 

Even IDE will sometimes complete from a timer on an error.

> And does local_irq_restore() need to execute even more costy "popf" when 
> it makes a transition from disabled to disabled state? What's 
> local_irq_restore semantics --- is it allowed to use local_irq_restore for 
> transition from interrupt-enabled state into interrupt-disabled state?

If you are worried about performance the network layer has _irq variants
of various functions that are faster and can only be called from the
right context (eg kfree_skb_irq), so you could do two versions of that
code.

Alan
