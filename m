Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXKIXl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXKIXl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXKIXlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:41:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53503 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760801AbXKIXlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:41:16 -0500
Date: Fri, 9 Nov 2007 23:41:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] Char: rocket, printk cleanup
Message-ID: <20071109234111.73bdb0b0@the-village.bc.nu>
In-Reply-To: <25731202891966530041.slaby@pripojeni.net>
References: <133622706419279219.slaby@pripojeni.net>
	<25731202891966530041.slaby@pripojeni.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -	printk(KERN_INFO "rp_do_receive(%d)...", ToRecv);
> +	printk(KERN_INFO "rp_do_receive(%d)...\n", ToRecv);

The missing \n was intentional looking at the old code, and meant you got
a lot of trace per line for debugging. The KERN_ additions are the
breakage here.

We might as well just lose them, we have proper debuggers now and they
are useless with \n, and pretty useless without.
