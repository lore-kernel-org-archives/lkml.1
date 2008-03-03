Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbYCCWYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbYCCWYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYCCWY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:24:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761266AbYCCWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:24:24 -0500
Date: Mon, 3 Mar 2008 14:23:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
In-Reply-To: <200803032127.30761.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803031422180.2979@woody.linux-foundation.org>
References: <20080225090316.GA420@elf.ucw.cz> <20080303154831.22a4eb14@core> <20080303172410.GA13869@elf.ucw.cz> <200803032127.30761.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Mar 2008, Rafael J. Wysocki wrote:
> 
> Well something like this could happen, in theory, on a "32-bit" architecture
> with a 16-bit bus.

No it couldn't.

That would only be true if there is no cache, and no cache coherency.

Basically, Linux requires a cache-coherent architecture to work in SMP. 
Anything else is insane (except as a cluster).

So there is no way we can see partial updates, except with terminally 
broken hardware that we would never support anyway for tons of other 
reasons.

		Linus
