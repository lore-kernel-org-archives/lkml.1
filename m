Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZHNPdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZHNPdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZHNPds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:33:48 -0400
Received: from waste.org ([173.11.57.241]:55391 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbZHNPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:33:48 -0400
Subject: Re: [PATCH] drivers/net: fixed drivers that support netpoll use
 ndo_start_xmit()
From: Matt Mackall <mpm@selenic.com>
To: DDD <Dongdong.deng@windriver.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Ashfield, Bruce" <Bruce.Ashfield@windriver.com>,
       jason.wessel@windriver.com
In-Reply-To: <1250226751.29401.82.camel@dengdd-desktop>
References: <1250226751.29401.82.camel@dengdd-desktop>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 10:33:39 -0500
Message-Id: <1250264019.3807.1301.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 13:12 +0800, DDD wrote:
> The NETPOLL API requires that interrupts remain disabled in
> netpoll_send_skb(). The use of spin_lock_irq() and spin_unlock_irq()
> in the NETPOLL API callbacks causes the interrupts to get enabled and
> can lead to kernel instability.
> 
> The solution is to use spin_lock_irqsave() and spin_unlock_restore()
> to prevent the irqs from getting enabled while in netpoll_send_skb().
> 
> Call trace:
> netpoll_send_skb()
> {
>    -> local_irq_save(flags)
>      ---> dev->ndo_start_xmit(skb, dev)
>          ---> spin_lock_irq()
>          ---> spin_unlock_irq() *******here would enable the interrupt.
>               ...
>    -> local_irq_restore(flags)
> }
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Acked-by: Bruce Ashfield <bruce.ashfield@windriver.com>

Acked-by: Matt Mackall <mpm@selenic.com>

Perhaps we should also have a WARN_ONCE if start_xmit returns with
interrupts enabled?

-- 
http://selenic.com : development and support for Mercurial and Linux


