Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZDHXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZDHXHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZDHXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:07:16 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47422 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbZDHXHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:07:15 -0400
Date: Wed, 8 Apr 2009 16:06:21 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: mschmidt@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] skge: fix occasional BUG during MTU change
Message-ID: <20090408160621.06f4e556@s6510>
In-Reply-To: <20090408.160152.56341911.davem@davemloft.net>
References: <20090407183623.7545bb0b@leela>
	<20090408.160152.56341911.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 16:01:52 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Michal Schmidt <mschmidt@redhat.com>
> Date: Tue, 7 Apr 2009 18:36:23 +0200
> 
> > The BUG_ON(skge->tx_ring.to_use != skge->tx_ring.to_clean) in skge_up()
> > was sometimes observed when setting MTU.
> > 
> > skge_down() disables the TX queue, but then reenables it by mistake via
> > skge_tx_clean().
> > Fix it by moving the waking of the queue from skge_tx_clean() to the
> > other caller. And to make sure start_xmit is not in progress on another
> > CPU, skge_down() should call netif_tx_disable().
> > 
> > The bug was reported to me by Jiri Jilek whose Debian system sometimes
> > failed to boot. He tested the patch and the bug did not happen anymore.
> > 
> > Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> 
> Stephen, an ACK possibly?

I wanted to test on real hardware, and am offsite this week.
