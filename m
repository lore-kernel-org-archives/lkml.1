Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZAaJZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZAaJZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 04:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAaJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 04:25:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50593 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750720AbZAaJZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 04:25:38 -0500
Date: Sat, 31 Jan 2009 09:25:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
Message-ID: <20090131092509.7c658b22@lxorguk.ukuu.org.uk>
In-Reply-To: <20090131033035.GA26640@elte.hu>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3>
	<20090131033035.GA26640@elte.hu>
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

> One minor worry i have: these wakeup calls are _very_ common in the 
> kernel, and this patch adds an extra parameter to it that is unused (NULL) 
> in 99% of the cases.

And in most of the cases it is used is constant for the waitqueue anyway
or appears to be (eg the tty patch). I don't think we should be stacking
extra parameters on all those zillions of calls made all over the kernel
and for no purpose - so the existing wakeup functions should stay as is
for performance as well as for size (which due to cache pressure is
performance).

Alan
