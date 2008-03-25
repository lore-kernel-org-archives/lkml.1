Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbYCYXto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbYCYXto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbYCYXtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:49:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40730
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757513AbYCYXte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:49:34 -0400
Date: Tue, 25 Mar 2008 16:49:27 -0700 (PDT)
Message-Id: <20080325.164927.249210766.davem@davemloft.net>
To: peterc@gelato.unsw.edu.au
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org,
       ianw@gelato.unsw.edu.au
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <87tziu5q37.wl%peter@chubb.wattle.id.au>
References: <Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
	<20080325.162244.61337214.davem@davemloft.net>
	<87tziu5q37.wl%peter@chubb.wattle.id.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Chubb <peterc@gelato.unsw.edu.au>
Date: Wed, 26 Mar 2008 10:41:32 +1100

> It's actually harder than it looks.  Ian Wienand just finished his
> Master's project in this area, so we have *lots* of data.  The main
> issue is that, at least on Itanium, you have to turn off the hardware
> page table walker for hugepages if you want to mix superpages and
> standard pages in the same region. (The long format VHPT isn't the
> panacea we'd like it to be because the hash function it uses depends
> on the page size).  This means that although you have fewer TLB misses
> with larger pages, the cost of those TLB misses is three to four times
> higher than with the standard pages.

If the hugepage is more than 3 to 4 times larger than the base
page size, which it almost certainly is, it's still an enormous
win.

> Other architectures (where the page size isn't tied into the hash
> function, so the hardware walked can be used for superpages) will have
> different tradeoffs.

Right, admittedly this is just a (one of many) strange IA64 quirk.
