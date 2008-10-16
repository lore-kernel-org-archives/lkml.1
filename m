Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYJPKxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYJPKxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYJPKww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:52:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751757AbYJPKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:52:52 -0400
Date: Thu, 16 Oct 2008 11:52:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>,
       Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH 0/5] SIGWINCH problem with terminal apps still alive
Message-ID: <20081016115202.090a74cd@lxorguk.ukuu.org.uk>
In-Reply-To: <20081016122741.3b89f6f3@merlin.oi.pg.gda.pl>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
	<20081012210140.15cecf78@merlin.oi.pg.gda.pl>
	<20081012212244.117852e0@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131155280.5750@be1.lrz>
	<20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131359310.6408@be1.lrz>
	<20081014145104.24aa96d0@merlin.oi.pg.gda.pl>
	<20081014161157.0194c5c6@merlin.oi.pg.gda.pl>
	<20081016122741.3b89f6f3@merlin.oi.pg.gda.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and signal generated. In case of pty ioctl() on slave side it just sets
> pty size variables, generates SIGWINCH, but terminal is not changed so
> a terminal app will go crazy now. I propose changes which lead to more
> consistent handling:

It sets the tty and pty side variables.

> Now if xterm resizes itself then a program on slave gets its signal
> but if this program sets terminal sizes by ioctl then only xterm gets
> the SIGWINCH signal and could read desired sizes by ioctl and then
> resize itself and set valid sizes on slave side by another ioctl() call.
> If it not supports this method then there will be no changes on slave
> side. I think that it is more proper so on the slave side we will see
> always actual values and if terminal resizes we will get SIGWINCH. 

The current and historic behaviour is I believe correct and matches other
Unixes.

Your patch doesn't really seem to make a lot of sense either. You add pty
special cases in places they are not needed and you pass various extra
arguments to functions that don't need them.

I did actually have a glance at the pty signalling question a couple of
days ago while further tidying up the default resize logic - see the
ttydev tree. I'm cautious about changing the signal behaviour however
without having a hard look to see whether any other Unixen has that
behaviour currently as we may risk breaking stuff.

Alan
