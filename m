Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZI3XW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZI3XW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZI3XW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:22:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55934
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761AbZI3XW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:22:57 -0400
Date: Wed, 30 Sep 2009 16:23:16 -0700 (PDT)
Message-Id: <20090930.162316.123663794.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jarkao2@gmail.com, albcamus@gmail.com, parag.lkml@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Fix sock_wfree() race
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ABBDB54.4000609@gmail.com>
References: <4ABA262F.9040407@gmail.com>
	<4ABBD18A.70208@gmail.com>
	<4ABBDB54.4000609@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 24 Sep 2009 22:49:24 +0200

> [PATCH] net: Fix sock_wfree() race
> 
> Commit 2b85a34e911bf483c27cfdd124aeb1605145dc80
> (net: No more expensive sock_hold()/sock_put() on each tx)
> opens a window in sock_wfree() where another cpu
> might free the socket we are working on.
> 
> A fix is to call sk->sk_write_space(sk) while still
> holding a reference on sk.
> 
> 
> Reported-by: Jike Song <albcamus@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied to net-2.6 and I'll queue this up for -stable.

Thanks!
