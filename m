Return-Path: <linux-kernel-owner+w=401wt.eu-S935170AbYD1Oy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935170AbYD1Oy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbYD1OyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:54:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:58477 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531AbYD1OyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=I2sKiNTyrt5dHGbLjfPCAsaxXHt9K7UX1kMdkQ+S9fTpbiYN4An6WOefYy+i2zHhqc4u2JmIv9nQfbZQwe0t7+yW7GkJ8+2pSHFEzKbQ3KIisv53obf2Zvj97cAJmb82FvKpqIR/zixUJyerCAOV5yM2wjftvGbNKcPymK1OL+Q=
Date: Mon, 28 Apr 2008 22:53:12 +0800 (CST)
Message-Id: <20080428.225312.58450957.xiyou.wangcong@gmail.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [Patch]net/xfrm/xfrm_policy.c: replace timer with delayed_work
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080427011809.GA662@gondor.apana.org.au>
References: <20080216.235534.237382205.xiyou.wangcong@gmail.com>
	<20080427011809.GA662@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 27 Apr 2008 09:18:09 +0800
> On Sat, Feb 16, 2008 at 11:55:34PM +0800, WANG Cong wrote:
> > 
> > As suggested by Herbert, using workqueue is better than timer
> > for net/xfrm/xfrm_policy.c, so replace them with delayed_work.
> > 
> > Note that, this patch is not fully tested, just compile and
> > run as a whole on an Intel Core Duo matchine. So should be
> > in -mm first.
> > 
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David Miller <davem@davemloft.net>
> 
> Sorry for the extremely long delay, but I've finally made it
> to this email in my backlog :)
> 
> The patch looks OK except for one thing, the read-write spin
> lock needs to disable BH now that it's moved to process context.
> Otherwise we'll get dead-locks with the softirq path taking the
> same lock.

Do you mean ->lock of struct xfrm_policy?
OK. I will recook these two patches soon.

Thanks for review.
