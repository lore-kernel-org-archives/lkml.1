Return-Path: <linux-kernel-owner+w=401wt.eu-S937250AbXFHBr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937250AbXFHBr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXFHBrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:47:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55197
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932072AbXFHBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:47:15 -0400
Date: Thu, 07 Jun 2007 18:47:31 -0700 (PDT)
Message-Id: <20070607.184731.10907840.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1HvqZB-0003Vc-00@dorka.pomaz.szeredi.hu>
References: <E1Hvo2m-00038P-00@dorka.pomaz.szeredi.hu>
	<20070605.224128.104032917.davem@davemloft.net>
	<E1HvqZB-0003Vc-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 06 Jun 2007 10:08:29 +0200

> There are races involving the garbage collector, that can throw away
> perfectly good packets with AF_UNIX sockets in them.
> 
> The problems arise when a socket goes from installed to in-flight or
> vice versa during garbage collection.  Since gc is done with a
> spinlock held, this only shows up on SMP.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

I'm going to hold off on this one for now.

Holding all of the read locks kind of defeats the purpose of using
the per-socket lock.

Can't you just lock purely around the receive queue operation?
