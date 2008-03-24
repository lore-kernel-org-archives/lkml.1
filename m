Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYCXLej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYCXLej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 07:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbYCXLe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 07:34:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:8225 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833AbYCXLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 07:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jyrvmxBVQLhuo0nWWrdBdPbgU/5aqchtPzFLBFzpCgcq0iyb1QD3xT3MyuxZrdkMOu8Vg6SnPh9TuWpAmd4xnhwM3hoM+guSAw2QVJzK8sjq3hOQPFY9uF5uaNwyWtqrKCETxwpieTxCa++XszcLiV68eOMJfBVAfGkGLY5HYmY=
Message-ID: <89cb5ede0803240434s7fad3d09y7a422213407f1e90@mail.gmail.com>
Date: Mon, 24 Mar 2008 14:34:28 +0300
From: "Khaled Al-Hamwi" <khaled.linux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: spinlock BUG in qdisc_restart
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080323.031036.09404846.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <89cb5ede0803230023h49563614h57cad4a25d7753a4@mail.gmail.com>
	 <20080323.031036.09404846.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
> From: "Khaled Al-Hamwi" <khaled.linux@gmail.com>
> Date: Sun, 23 Mar 2008 10:23:20 +0300
>
> > [<c02845af>] netif_receive_skb+0x1fc/0x23e
> > [<e033b560>] MM_IndicateRxPackets+0x2be/0x379 [bcm5700]
> > [<e0342c26>] LM_ServiceInterrupts+0xac/0xc5 [bcm5700]
> > [<e0337768>] bcm5700_interrupt+0x13c/0x2bd [bcm5700]
>
> This backtrace is not from a driver that is in the upstream kernel
> sources.
>
> Please use the supported and upstream "tg3" driver for this hardware.
>
> Thank you.
>

Thank you for your reply.

I need to use the bcm5700 driver. Otherwise, I have to reimplemented
the changes that has been already implemented.

By the way, I found the reason for this bug and fixed it. It was
caused by the scheduling of NET_TX_SOFTIRQ. The conflict happens when
tx softirq is run.
I have already disabled rx softirq as I am processing the packets at
the interrupt level.


Thanks,
Khaled
