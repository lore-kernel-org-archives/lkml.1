Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbZHNXcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbZHNXcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 19:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZHNXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 19:32:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55251
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbZHNXcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 19:32:21 -0400
Date: Fri, 14 Aug 2009 16:32:32 -0700 (PDT)
Message-Id: <20090814.163232.234331420.davem@davemloft.net>
To: mpm@selenic.com
Cc: Dongdong.deng@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bruce.Ashfield@windriver.com,
       jason.wessel@windriver.com
Subject: Re: [PATCH] drivers/net: fixed drivers that support netpoll use
 ndo_start_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1250264019.3807.1301.camel@calx>
References: <1250226751.29401.82.camel@dengdd-desktop>
	<1250264019.3807.1301.camel@calx>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Fri, 14 Aug 2009 10:33:39 -0500

> On Fri, 2009-08-14 at 13:12 +0800, DDD wrote:
>> The NETPOLL API requires that interrupts remain disabled in
>> netpoll_send_skb(). The use of spin_lock_irq() and spin_unlock_irq()
>> in the NETPOLL API callbacks causes the interrupts to get enabled and
>> can lead to kernel instability.
>> 
>> The solution is to use spin_lock_irqsave() and spin_unlock_restore()
>> to prevent the irqs from getting enabled while in netpoll_send_skb().
 ...
>> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> Acked-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Applied, thanks everyone.

> Perhaps we should also have a WARN_ONCE if start_xmit returns with
> interrupts enabled?

Probably a good idea.
