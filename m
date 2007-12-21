Return-Path: <linux-kernel-owner+w=401wt.eu-S1765320AbXLUAh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765320AbXLUAh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXLUAhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:37:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49355
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbXLUAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:37:09 -0500
Date: Thu, 20 Dec 2007 16:37:08 -0800 (PST)
Message-Id: <20071220.163708.08256310.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: gallatin@myri.com, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NETDEV]: remove netif_running() check from
 myri10ge_poll()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071220160518.fa65ac90.akpm@linux-foundation.org>
References: <47602AAA.8060204@myri.com>
	<20071212.110243.202840959.davem@davemloft.net>
	<20071220160518.fa65ac90.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 20 Dec 2007 16:05:18 -0800

> On Wed, 12 Dec 2007 11:02:43 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Andrew Gallatin <gallatin@myri.com>
> > Date: Wed, 12 Dec 2007 13:38:34 -0500
> > 
> > > Remove the bogus netif_running() check from myri10ge_poll().
> > > 
> > > This eliminates any chance that myri10ge_poll() can trigger
> > > an oops by calling netif_rx_complete() and returning
> > > with work_done == budget.
> > > 
> > > Signed-off-by: Andrew Gallatin <gallatin@myri.com>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> hm, eight days old, fixes a possible oops and hasn't been merged anywhere
> yet?
> 
> I'll put it in my for-2.6.24-via-other-subsystem queue.

This actually adds a bug back into the code.

We're trying to work out how to cleanly break out of
the net_rx_action() ->poll() loop when a device is
brought down yet getting hammered with packets.

I'll try to devote some time to this over the weekend,
meanwhile just toss this patch, we know it's an issue
that all the drivers need to get audited for but we
can't fix that until the above paragraph stuff is worked
out.

Thanks.
