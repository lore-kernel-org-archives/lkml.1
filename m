Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXHNMZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXHNMZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 08:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757437AbXHNMZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 08:25:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38062 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756368AbXHNMZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 08:25:34 -0400
Date: Tue, 14 Aug 2007 13:33:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is broken
Message-ID: <20070814133319.1a8a4871@the-village.bc.nu>
In-Reply-To: <200708141241.44021.vda.linux@googlemail.com>
References: <200708141241.44021.vda.linux@googlemail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> b) Make recv(fd, buf, size, flags) and send(fd, buf, size, flags);
>    work with non-socket fds too, for flags==0 or flags==MSG_DONTWAIT.
>    (it's ok to fail with "socket op on non-socket fd" for other values
>    of flags)

I think that makes a lot of sense, and to be honest other MSG_ flags make
useful sense and have meaningful semantics that might be helpful
elsewhere if ever coded that way.

If you want to do this the first job is going to be to sort out the way
non-block is propogated to device driver read/write handlers. At the
moment they all check filp->f_flags

Alan
