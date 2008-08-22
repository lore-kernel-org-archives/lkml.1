Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbYHVSrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbYHVSrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYHVSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:47:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33234 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752412AbYHVSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:47:13 -0400
Date: Fri, 22 Aug 2008 19:24:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rdunlap@xenotime.net, toralf.foerster@gmx.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com
Subject: Re: build issue #564 for v2.6.27-rc4 : undefined reference to
 `NS8390p_init'
Message-ID: <20080822192415.1984d1c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20080822110902.432dd99e.akpm@linux-foundation.org>
References: <200808221033.46997.toralf.foerster@gmx.de>
	<Pine.LNX.4.64.0808221025070.6100@shark.he.net>
	<20080822181234.2f33e993@lxorguk.ukuu.org.uk>
	<20080822110902.432dd99e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For the record, and from memory, there were three patches.

I would go take a look at the archive if I was you: there were bits from
Ingo and others too.

The diff you are looking for however appears to be this, which reverts part
of the follow on patches to the correct original. I shall however refrain
from looking smug because while the original wd patch was right I'm also the
idiot who put the bug back into the tree.

Signed-off-by: Alan 'pass the paper bags' Cox <alan@redhat.com>

--- drivers/net/wd.c~	2008-08-22 19:17:01.000000000 +0100
+++ drivers/net/wd.c	2008-08-22 19:17:01.000000000 +0100
@@ -337,7 +337,7 @@
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = ei_poll;
 #endif
-	NS8390p_init(dev, 0);
+	NS8390_init(dev, 0);
 
 #if 1
 	/* Enable interrupt generation on softconfig cards -- M.U */
