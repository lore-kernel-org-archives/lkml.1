Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXKBMuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXKBMuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXKBMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:50:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45377 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753501AbXKBMuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:50:03 -0400
Date: Fri, 2 Nov 2007 12:51:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [IRDA] IRNET: Fix build when TCGETS2 is defined.
Message-ID: <20071102125109.11d2efb4@the-village.bc.nu>
In-Reply-To: <20071101.154123.102568743.davem@davemloft.net>
References: <200711011959.lA1JxPWc003735@hera.kernel.org>
	<20071101223010.6780cc98@the-village.bc.nu>
	<20071101.154123.102568743.davem@davemloft.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Nothing anywhere in the kernel but the core ioctl code should be
> > processing TCGET/TCSET calls.
> > 
> > Just delete them. It will return -ENOIOCTLCMD and the core tty layer will
> > process them.
> 
> Ok.

One set of patches in testing.

For the irda non-tty device its almost impossible to hack up a sane
solution except to delete the junk. pppd has supported "notty" for some
years so there is no excuse for that still being present.

The ones with actual ttys can be done cleanly so I've

- split n_tty_ioctl
- used the split to create tty_mode_ioctl() which an ldisc can use for
generic mode handling
- extracted the flush method so it can be used more cleanly by ppp etc

Patches to follow shortly for review

Alan
