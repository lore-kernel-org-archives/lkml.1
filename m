Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXF3J6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXF3J6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXF3J6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:58:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55497 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753555AbXF3J6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:58:08 -0400
Date: Sat, 30 Jun 2007 11:04:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Curry <pacman@TheWorld.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty O_NONBLOCK spooky action at a distance
Message-ID: <20070630110405.6f3de1f2@the-village.bc.nu>
In-Reply-To: <200706300735.l5U7Z72L191585@shell01.TheWorld.com>
References: <200706300735.l5U7Z72L191585@shell01.TheWorld.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 03:35:07 -0400 (EDT)
Alan Curry <pacman@TheWorld.com> wrote:

> Short version: writing to a tty with O_NONBLOCK will block if there is
> another, unrelated process already blocking inside a write() to the same tty.

I sent Linus patches to fix this minor DoS flaw some time ago. I've
no idea why they still didn't make the base kernel. They are however in
the -mm tree and I'm suprised vendors haven't picked them up. I'll push
them again for 2.6.23-rc1 if Andrew doesn't do it himself.

In general currently I'd strongly recommend the -mm tree. It is
the only kernel which has revoke() support - which is needed to deal with
all sorts of interesting abuses on any system with multiple console users
(SELinux may also save you here). It's also got a lot of ATA layer fixes
so is much more reliable with SATA or with libata PATA at the moment.

Of course the fact it has all the cool stuff means it may also have more
bugs but you can't have everything.

Alan
