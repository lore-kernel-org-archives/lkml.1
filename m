Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab0CMJLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:11:38 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41717 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab0CMJLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:11:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VFoFfFViRiv7mZzytxItM5yVwyKqkPZ6aeWN+Yvn3AzDKGbIwkAu5vC/9ad7ZhNnvs
         FKoNcZBomBLrGhlnmi4eWh0Foky1XvQHDHmH14dn2UX/SzfBSIH9+4RtoFhv3spHFm0f
         B7+Xe2997lUmy8XC0ZMvECoLkY0gphJN98NYM=
Subject: Re: [PATCH v4 2/7] net: remove old tcp_optlen function
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Michael Chan <mchan@broadcom.com>,
       Simon Horman <horms@verge.net.au>
In-Reply-To: <4B9AC8C5.2010300@gmail.com>
References: <4B98D592.6040301@gmail.com> <4B98D9A2.8060603@gmail.com>
	 <4B9A40BC.4030301@gmail.com> <20100312174656.GA12175@bicker>
	 <4B9AC8C5.2010300@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Mar 2010 10:11:28 +0100
Message-ID: <1268471488.2947.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 mars 2010 à 18:05 -0500, William Allen Simpson a écrit :

> In this particular instance, I suggest that you take a look at all the
> places that gso_size is set, and cross index with all the code paths that
> place these TCP headers onto the txq without a check of doff -- as I did!
> 
> I'll specifically mention the tun and virtio_net devices, but I'm also
> particularly concerned with af_packet.c and skbuff.c -- and the general
> problem with inet_lro.c, too.
> 
> Amazingly enough, folks sometimes use Linux for routers....
> --

David already pointed out fact that this code path is not used in
forwardind / routing path. Your assumptions are clearly wrong.

Can you sit down and understand this difference ?

Only *locally* generated trafic by linux kernel can enter this path.

And if a bug in linux core network stack can feed any driver a buggy
skb, bad things can happen, even if a driver is perfect.

Please point out _this_ bug _if_ it really exists, so that we can
correct this bug instead of hiding it in one thousand of drivers.

Your attacks make no sense, you know nothing about linux kernel
internals and assume it was written like other projects you were
involved to.


