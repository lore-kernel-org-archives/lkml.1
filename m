Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZHQI3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZHQI3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZHQI3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:29:01 -0400
Received: from www84.your-server.de ([213.133.104.84]:39721 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbZHQI3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:29:00 -0400
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <20090817091524.33f99737@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	 <1250455590.28540.10.camel@wall-e>
	 <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	 <20090816163422.a147a918.akpm@linux-foundation.org>
	 <20090817074820.3585206b@lxorguk.ukuu.org.uk>
	 <1250495182.20837.27.camel@wall-e>
	 <20090817091524.33f99737@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 10:28:56 +0200
Message-Id: <1250497736.20837.39.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 17.08.2009, 09:15 +0100 schrieb Alan Cox:
> > > All over the kernel unlocked function versions have a leading _ name.
> > > It's the kernel convention.
> > 
> > Thats is not true in every case. Have a look at list.h - That was the
> > pattern i have implemented the new kfifo API.
> 
> Of course it isn't true in every case. Show me a *single* kernel
> convention that is. It's also not true in no cases. foo_locked isn't used
> much at all.
> 
> > The main reason to do this was to design a cleaner interface. Because
> > there are very few users of this API, i thought it is a good time and
> > chance to do this.
> > 
> > My first draft version does also not renamed this functions, but there
> > was some concerns about the new functionality without modification the
> > function names.
> > 
> > Also the remove of the spinlock made is necessary to rename the
> > functions for preventing miss-use by out-of-kernel-tree drivers.
> 
> So if you didn't remove the spinlock you wouldn't have to change the API
> and patch all the drivers.
>  

No. The kfifo struct in place does made it also necessary to patch all
this drivers. 

And the spinlock is in most cases useless, because the API works fine if
only one reader and one writer is using the fifo. This is the common
case.

> > I think the break is not so hard if you believe. All you have to do is
> > to replace or kfifo_get() into kfifo_out_locked() and kfifo_put() into
> > kfifo_in_locked() if you really need the old behavior.
> 
> Which is very long winded. If you want longwinded and without breaking
> stuff you can use
> 
> foo_unlocked() or unlocked_foo()
> 
> which do occur in the kernel (eg ioctl) when we want people to be
> specifically aware of it although according to grep a little less often
> than foo_locked() [discounting foo_is_locked which is general tests]
> 

If you like it is very easy to add a compatibility layer, which restores
the old function names. But for what, only for very few users who
depends on it? This will only waste the name space.
  

