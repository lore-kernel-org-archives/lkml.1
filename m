Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbZHQIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbZHQIxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZHQIxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:53:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55109 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757389AbZHQIx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:53:29 -0400
Date: Mon, 17 Aug 2009 09:53:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-ID: <20090817095349.4cf8d3c5@lxorguk.ukuu.org.uk>
In-Reply-To: <1250497736.20837.39.camel@wall-e>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	<20090816163422.a147a918.akpm@linux-foundation.org>
	<20090817074820.3585206b@lxorguk.ukuu.org.uk>
	<1250495182.20837.27.camel@wall-e>
	<20090817091524.33f99737@lxorguk.ukuu.org.uk>
	<1250497736.20837.39.camel@wall-e>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And the spinlock is in most cases useless, because the API works fine if
> only one reader and one writer is using the fifo. This is the common
> case.

That is one good argument for fixing the naming. The USB serial code
probably can be persuaded to use the  single reader/writer assumption as
well.

> If you like it is very easy to add a compatibility layer, which restores
> the old function names. But for what, only for very few users who
> depends on it? This will only waste the name space.

Ooh the tragedy, we are short many things but namespace strangely is not
one of them. Especially when the names all start kfifo_ and __kfifo_, a
namespace much in demand by other code.

I'd rather have the old names, or the new names than some kind of gunge
middle layer of both. Either choice is better.
