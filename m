Return-Path: <linux-kernel-owner+w=401wt.eu-S937071AbXGQX3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937071AbXGQX3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759309AbXGQX3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:29:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54290 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757890AbXGQX3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:29:22 -0400
Date: Wed, 18 Jul 2007 00:35:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Simmons <jsimmons@infradead.org>,
       Paul Fulghum <paulkf@microgate.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
Message-ID: <20070718003534.09241186@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
	<alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
	<469D2810.9080109@microgate.com>
	<alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
	<alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> In that case, we might as well just always do the scheduled_delayed_work() 
> with a zero timeout as per the earlier patch. I'd still like to know who 
> *cares*, though? Why not leave it at 1?

I don't think it really matters too much on modern systems so long as we
keep the flush_to_ldisc out of IRQ context. Historically we tried to
batch the ldisc processing but I doubt any modern box cares too much
