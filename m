Return-Path: <linux-kernel-owner+w=401wt.eu-S932761AbXGRNgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbXGRNgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXGRNgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:36:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41549 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754491AbXGRNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:36:36 -0400
Date: Wed, 18 Jul 2007 14:42:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Cc: linux-kernel@vger.kernel.org, teheo@novell.com
Subject: Re: i386: pata_cs5520 does not work
Message-ID: <20070718144212.3289e86c@the-village.bc.nu>
In-Reply-To: <20070716.091928.111205836.takada@mbf.nifty.com>
References: <20070716.014115.193701589.takada@mbf.nifty.com>
	<20070715183924.0a6c992b@the-village.bc.nu>
	<20070716.091928.111205836.takada@mbf.nifty.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'll take a look at this next week. Can you send me a dmesg of the
> > working case and an lspci -vvxxx
> 
> Thanks. attached 2 dmesgs(2.6.21 with pata_cs5520, 2.6.22 with IDE) and output of lspci.

Nothing obviously wrong. What happens if you find the line

if (!iomap[0] || !iomap[1] || !iomap[2] || !iomap[3] || !iomap[4])
		return -ENOMEM;

in pata_cs5520.c and change the end from return -ENOMEM to 

if (!iomap[0] || !iomap[1] || !iomap[2] || !iomap[3] || !iomap[4])
		panic("IO MAP");

This should help identify where the problem occurs
