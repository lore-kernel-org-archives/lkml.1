Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYEABLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYEABLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYEABLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:11:35 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58219 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYEABLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:11:34 -0400
Date: Thu, 1 May 2008 09:11:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [Patch]net/xfrm/xfrm_policy.c: replace timer with delayed_work
Message-ID: <20080501011123.GA4060@gondor.apana.org.au>
References: <20080216.235534.237382205.xiyou.wangcong@gmail.com> <20080427011809.GA662@gondor.apana.org.au> <20080428.225312.58450957.xiyou.wangcong@gmail.com> <20080428151342.GA12007@gondor.apana.org.au> <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:06:55AM +0800, WANG Cong wrote:
> 
> Hi, Herbert.
> 
> I referenced the book Linux Device Drivers, it is said that
> the work function in workqueue can sleep, that is to say, it only
> works in process context, so we don't need the disable the lock
> in softirq, which is interrupt context, right?

Because it can sleep, you must disable BH for locks that can
be taken on the softirq path as otherwise a softirq can come
in, try to take the lock again and dead-lock.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
