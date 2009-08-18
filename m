Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbZHRFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbZHRFrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZHRFrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:47:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:44567 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZHRFrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:47:21 -0400
Subject: Re: [PATCH] drivers/net: fixed drivers that support netpoll use
	ndo_start_xmit()
From: DDD <Dongdong.deng@windriver.com>
To: David Miller <davem@davemloft.net>, mpm@selenic.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce.Ashfield@windriver.com, jason.wessel@windriver.com
In-Reply-To: <20090814.163232.234331420.davem@davemloft.net>
References: <1250226751.29401.82.camel@dengdd-desktop>
	 <1250264019.3807.1301.camel@calx>
	 <20090814.163232.234331420.davem@davemloft.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Aug 2009 13:59:26 +0800
Message-Id: <1250575166.29401.183.camel@dengdd-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 18 Aug 2009 05:47:00.0657 (UTC) FILETIME=[4E542210:01CA1FC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 16:32 -0700, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Fri, 14 Aug 2009 10:33:39 -0500
> 
> > On Fri, 2009-08-14 at 13:12 +0800, DDD wrote:
> >> The NETPOLL API requires that interrupts remain disabled in
> >> netpoll_send_skb(). The use of spin_lock_irq() and
> spin_unlock_irq()
> >> in the NETPOLL API callbacks causes the interrupts to get enabled
> and
> >> can lead to kernel instability.
> >> 
> >> The solution is to use spin_lock_irqsave() and
> spin_unlock_restore()
> >> to prevent the irqs from getting enabled while in
> netpoll_send_skb().
> ...
> >> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> >> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> >> Acked-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> > 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> Applied, thanks everyone.
Thanks. :-)

> 
> > Perhaps we should also have a WARN_ONCE if start_xmit returns with
> > interrupts enabled?
> 
> Probably a good idea.
I think it is a good idea too, thanks for your suggestion, Matt.
I will do a tiny patch for it shortly.


Dongdong
