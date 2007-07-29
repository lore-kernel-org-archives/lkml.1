Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXG2HQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXG2HQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 03:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXG2HQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 03:16:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58902
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755609AbXG2HQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 03:16:01 -0400
Date: Sun, 29 Jul 2007 00:16:00 -0700 (PDT)
Message-Id: <20070729.001600.74751290.davem@davemloft.net>
To: marcel@holtmann.org
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] fix endianness bug in l2cap_sock_listen()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1185547278.13228.15.camel@violet>
References: <E1IEPNS-0005RS-7o@ZenIV.linux.org.uk>
	<1185547278.13228.15.camel@violet>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Fri, 27 Jul 2007 16:41:18 +0200

> > We loop through psm values, calling __l2cap_get_sock_by_addr(psm, ...)
> > until we get NULL; then we set ->psm of our socket to htobs(psm).
> > IOW, we find unused psm value and put it into our socket.  So far, so
> > good, but...  __l2cap_get_sock_by_addr() compares its argument with
> > ->psm of sockets.  IOW, the entire thing works correctly only on
> > little-endian.  On big-endian we'll get "no socket with such psm"
> > on the first iteration, since we won't find a socket with ->psm == 0x1001.
> > We will happily conclude that 0x1001 is unused and slap htobs(0x1001)
> > (i.e. 0x110) into ->psm of our socket.  Of course, the next time around
> > the same thing will repeat and we'll just get a fsckload of sockets
> > with the same ->psm assigned.
> > 
> > Fix: pass htobs(psm) to __l2cap_get_sock_by_addr() there.  All other
> > callers are already passing little-endian values and all places that
> > store something in ->psm are storing little-endian.
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Applied.

> Dave, all four patches are good and should go in sooner than later. If
> you want me to put them into my tree first, then I can do that or you
> can apply them directly. You choice.

I'll take care of these, thanks.
