Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbZJ3T0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbZJ3T0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbZJ3T0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:26:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59414
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbZJ3T0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:26:15 -0400
Date: Fri, 30 Oct 2009 12:26:40 -0700 (PDT)
Message-Id: <20091030.122640.137286305.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: francis.moro@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AEB0059.1050400@gmail.com>
References: <38b2ab8a0910300144i7a3c190fi9aa3d079c9cdb754@mail.gmail.com>
	<4AEACD88.8080108@gmail.com>
	<4AEB0059.1050400@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 30 Oct 2009 16:03:53 +0100

> [PATCH take2] net: fix sk_forward_alloc corruption
> 
> On UDP sockets, we must call skb_free_datagram() with socket locked,
> or risk sk_forward_alloc corruption. This requirement is not respected
> in SUNRPC.
> 
> Add a convenient helper, skb_free_datagram_locked() and use it in SUNRPC
> 
> Reported-by: Francis Moreau <francis.moro@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

I've tentatively applied this to my net-2.6 tree, I won't
push it out until we have positive testing results.
