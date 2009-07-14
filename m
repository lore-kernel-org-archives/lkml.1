Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZGNQEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZGNQEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZGNQE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:04:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54465
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbZGNQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:04:28 -0400
Date: Tue, 14 Jul 2009 09:04:32 -0700 (PDT)
Message-Id: <20090714.090432.13343695.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
 usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090710080247.GA2693@gondor.apana.org.au>
References: <20090709.171355.09466097.davem@davemloft.net>
	<20090710080017.GA24168@localhost>
	<20090710080247.GA2693@gondor.apana.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 10 Jul 2009 16:02:47 +0800

> On Fri, Jul 10, 2009 at 04:00:17PM +0800, Wu Fengguang wrote:
>> 
>> The (sk_allocation & ~__GFP_WAIT) cases should be rare, but I guess
>> the networking code shall do it anyway, because sk_allocation defaults
>> to GFP_KERNEL. It seems that currently the networking code simply uses
>> a lot of GFP_ATOMIC, do they really mean "I cannot sleep"?
> 
> Yep because they're done from softirq context.

Yes, this is the core issue.

All of Wu's talk about how "GFP_ATOMIC will wake up kswapd and
therefore can succeed just as well as GFP_KERNEL" is not relevant,
because GFP_ATOMIC means sleeping is not allowed.
