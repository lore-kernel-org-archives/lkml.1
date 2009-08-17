Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZHQIPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZHQIPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbZHQIPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:15:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33917 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757355AbZHQIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:15:21 -0400
Date: Mon, 17 Aug 2009 09:15:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-ID: <20090817091524.33f99737@lxorguk.ukuu.org.uk>
In-Reply-To: <1250495182.20837.27.camel@wall-e>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	<20090816163422.a147a918.akpm@linux-foundation.org>
	<20090817074820.3585206b@lxorguk.ukuu.org.uk>
	<1250495182.20837.27.camel@wall-e>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > All over the kernel unlocked function versions have a leading _ name.
> > It's the kernel convention.
> 
> Thats is not true in every case. Have a look at list.h - That was the
> pattern i have implemented the new kfifo API.

Of course it isn't true in every case. Show me a *single* kernel
convention that is. It's also not true in no cases. foo_locked isn't used
much at all.

> The main reason to do this was to design a cleaner interface. Because
> there are very few users of this API, i thought it is a good time and
> chance to do this.
> 
> My first draft version does also not renamed this functions, but there
> was some concerns about the new functionality without modification the
> function names.
> 
> Also the remove of the spinlock made is necessary to rename the
> functions for preventing miss-use by out-of-kernel-tree drivers.

So if you didn't remove the spinlock you wouldn't have to change the API
and patch all the drivers.
 
> I think the break is not so hard if you believe. All you have to do is
> to replace or kfifo_get() into kfifo_out_locked() and kfifo_put() into
> kfifo_in_locked() if you really need the old behavior.

Which is very long winded. If you want longwinded and without breaking
stuff you can use

foo_unlocked() or unlocked_foo()

which do occur in the kernel (eg ioctl) when we want people to be
specifically aware of it although according to grep a little less often
than foo_locked() [discounting foo_is_locked which is general tests]

