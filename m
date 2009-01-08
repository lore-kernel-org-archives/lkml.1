Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbZAHEot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbZAHEot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZAHEod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:44:33 -0500
Received: from kandzendo.ru ([195.178.208.66]:35432 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758682AbZAHEoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:44:32 -0500
Date: Thu, 8 Jan 2009 07:44:31 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Maurice Volaski <mvolaski@aecom.yu.edu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: swapper: page allocation failure. order:2, mode:0x4020 in 2.6.27
Message-ID: <20090108044431.GA16272@ioremap.net>
References: <a06240403c58ae633aba5@[129.98.90.227]> <20090108100917.65F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108100917.65F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, Jan 08, 2009 at 10:19:23AM +0900, KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> if stack dump has tg3_alloc_rx_skb(), that isn't bug. (maybe)
> tg3 network card often reqire non order-0 pages under irq/softirq context.
> 
> but linux memory manager can't drop any cache under irq/softirq context.
> therefore the allocation failure is relatively typical.
> 
> the allocation failure in packet receive (tg3_alloc_rx_skb) cause
> packet dropping and network peer resend the same packet.
> it decrease network performance a bit. but it doesn't cause any serious problem.
> 
> last problem is, why we should look this false-positive warning repeatedly.
> 
> 
> net-guys, if I say false thing, please fix.

You are right. You repeatedly get that message likely because of jumbo
frames enabled and fragmented ram which does not allow to allocate more
than order-0 pages.

-- 
	Evgeniy Polyakov
