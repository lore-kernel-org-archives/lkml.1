Return-Path: <linux-kernel-owner+w=401wt.eu-S937012AbXG0Ojg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937012AbXG0Ojg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbXG0OjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:39:19 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:35547 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761057AbXG0OjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:39:18 -0400
Subject: Re: [PATCH 1/4] fix endianness bug in l2cap_sock_listen()
From: Marcel Holtmann <marcel@holtmann.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <E1IEPNS-0005RS-7o@ZenIV.linux.org.uk>
References: <E1IEPNS-0005RS-7o@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:41:18 +0200
Message-Id: <1185547278.13228.15.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

> We loop through psm values, calling __l2cap_get_sock_by_addr(psm, ...)
> until we get NULL; then we set ->psm of our socket to htobs(psm).
> IOW, we find unused psm value and put it into our socket.  So far, so
> good, but...  __l2cap_get_sock_by_addr() compares its argument with
> ->psm of sockets.  IOW, the entire thing works correctly only on
> little-endian.  On big-endian we'll get "no socket with such psm"
> on the first iteration, since we won't find a socket with ->psm == 0x1001.
> We will happily conclude that 0x1001 is unused and slap htobs(0x1001)
> (i.e. 0x110) into ->psm of our socket.  Of course, the next time around
> the same thing will repeat and we'll just get a fsckload of sockets
> with the same ->psm assigned.
> 
> Fix: pass htobs(psm) to __l2cap_get_sock_by_addr() there.  All other
> callers are already passing little-endian values and all places that
> store something in ->psm are storing little-endian.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Dave, all four patches are good and should go in sooner than later. If
you want me to put them into my tree first, then I can do that or you
can apply them directly. You choice.

Regards

Marcel




