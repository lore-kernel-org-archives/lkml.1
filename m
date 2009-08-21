Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZHUP1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZHUP1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZHUP1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:27:06 -0400
Received: from waste.org ([173.11.57.241]:55324 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZHUP1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:27:05 -0400
Subject: Re: [PATCH 2/2] drivers/net: fixed drivers that support netpoll
 use ndo_start_xmit()
From: Matt Mackall <mpm@selenic.com>
To: DDD <Dongdong.deng@windriver.com>
Cc: David Miller <davem@davemloft.net>, Nicolas Pitre <nico@cam.org>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <1250861693.24178.22.camel@dengdd-desktop>
References: <1250861616.24178.20.camel@dengdd-desktop>
	 <1250861693.24178.22.camel@dengdd-desktop>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 10:26:19 -0500
Message-Id: <1250868379.3937.279.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 21:34 +0800, DDD wrote:
> The NETPOLL API requires that interrupts remain disabled in
> netpoll_send_skb(). The use of "A functions set" in the NETPOLL API
> callbacks causes the interrupts to get enabled and can lead to kernel
> instability.
> 
> The solution is to use "B functions set" to prevent the irqs from
> getting enabled while in netpoll_send_skb().
> 
> A functions set:
> local_irq_disable()/local_irq_enable()
> spin_lock_irq()/spin_unlock_irq()
> spin_trylock_irq()/spin_unlock_irq()
> 
> B functions set:
> local_irq_save()/local_irq_restore()
> spin_lock_irqsave()/spin_unlock_irqrestore()
> spin_trylock_irqsave()/spin_unlock_irqrestore()
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>

Both of these look good to me, thanks.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


