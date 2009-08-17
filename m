Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZHQIsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZHQIsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbZHQIsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:48:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45832 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757444AbZHQIsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:48:02 -0400
Date: Mon, 17 Aug 2009 09:48:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-ID: <20090817094842.1d97f841@lxorguk.ukuu.org.uk>
In-Reply-To: <20090817012150.9bb699ed.akpm@linux-foundation.org>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	<20090816163422.a147a918.akpm@linux-foundation.org>
	<20090817074820.3585206b@lxorguk.ukuu.org.uk>
	<20090817003617.2abe0a95.akpm@linux-foundation.org>
	<20090817090829.689a604c@lxorguk.ukuu.org.uk>
	<20090817012150.9bb699ed.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I simply pasted randomly from the regexp output. The __ semantic for the
less sanity checking/unlocked/non synchronizing version of an API is all
over the kernel. Not suprisingly as it seems to be a Linusism looking at
some of the old patch sets.

> > And remember: its very hard to fix existing API documentation and
books.
> > It's doubly dangerous (and IMHO a complete no-no) to change the API of an
> > interface if you don't change it such that old code will not reliably get
> > a compile time failure.
> 
> The patchet will cause unmigrated code to fail to build, won't it?

Yes but it won't fix the API docs.

So I still disagree with you. Adding _locked to the API end doesn't solve
any problems

You asked about mutexes but is get_locked() mutex locked, semaphore
locked, spinlocked, rwlocked ? So it doesn't do what you say.

What it does do is make the code more verbose, wider, more likely to go
over 80 columns and more typing.

Anyway I've made my point. I still think you are wrong on this one Andrew
but I think we have to simply continue to disagree.
