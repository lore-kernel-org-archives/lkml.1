Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYLGPI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYLGPI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 10:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYLGPIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 10:08:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33676 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753706AbYLGPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:08:50 -0500
Date: Sun, 7 Dec 2008 15:08:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207150856.7c0aed6a@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510812070602rdc62343q8d11471f71748595@mail.gmail.com>
References: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	<ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	<20081206160927.GA498@ioremap.net>
	<ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	<20081206165634.GA2516@ioremap.net>
	<ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
	<1228591926.3808.6.camel@nga>
	<20081206202620.GA9470@ioremap.net>
	<ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
	<20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<ac3eb2510812070602rdc62343q8d11471f71748595@mail.gmail.com>
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

> No, we have not. It is fine for modprobe doing that, as it is for any
> other binary too. It's also the usual glibc behavior for syslog(). Any
> userspace binary can access /dev/console any time. The kernel is not
> supposed to call modprobe to make /dev/console availabe.

Yes it is. The hotplug interface is designed to handle dynamic loading of
devices including the console. Likewise your hard disk interfaces you can
access at any time - guess what, those need loading too and if you put
your modprobe on a disk you've not got a driver loaded for that doesn't
work either.

> We are not reordering, we provide a registered /dev/console driver
> core device, not touching any driver, just to prevent the kernel
> module loader from going crazy.

You are reordering things.

The kernel module loader isn't going crazy either. The kernel module
loader is doings its job. The userspace then goes silly and the kernel
module loader correctly traps the problem, logs an error and tries to
continue things, but the initrd is it seems too broken to handle that
anyway.

Note that last small rather important detail - the kernel does detect
runaway modprobe loops already.

Alan
