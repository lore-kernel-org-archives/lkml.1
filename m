Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbXDPDQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbXDPDQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXDPDQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:16:52 -0400
Received: from mx34.mail.ru ([194.67.23.200]:4858 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754383AbXDPDQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:16:51 -0400
Date: Mon, 16 Apr 2007 07:12:56 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: ian <spyro@f2s.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ondrej Zajicek <santiago@crfreenet.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070416031256.GA30153@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070415220854.GA20373@localhost.localdomain> <20070415225049.GA27680@zarina> <20070416005722.GA6296@khazad-dum.debian.net> <1176690774.29389.175.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1176690774.29389.175.camel@wirenth>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:32:54AM +0100, ian wrote:
> On Sun, 2007-04-15 at 21:57 -0300, Henrique de Moraes Holschuh wrote:
> > 
> > No, that won't help much.  IMO, we want the sanest set of standard
> > attributes we can get, and weird as it might be, average reporting are
> > common properties of battery control firmware on laptops (maybe
> > because of SBS, but still...).
> 
> We need to think very carefully here.
> 
> charge, current, capacity, etc. are properties all batteries have, and
> the current values can all be sampled instantaneously.
> 
> funky values processed by 'black box' firmware are not universal
> properties of all batteries.
> 
> IOW, battery class should be for 'simple' battery types only.
> 
> perhaps rename it to simple battery class to make it distinct?
> 
> Userspace is the place to put the complications, in any case, and I see
> nothing wrong with having both a simple battery class AND other
> proprietary battery class an SBS battery class. (or a
> toshiba_proprietary_bios battery class or whatever).
> 
> Perhaps we need a 'libbattery.so' so that userspace can have a nice
> consistent interface?

Why? With current battery class we can do whatever everyone needs. No
need for wrappers.

Adding new properties is cheap and easy. Simple batteries using only
"simple" properties/attributes, and complicated batteries using
complicated attributes.

Because of your original design, simple batteries are stay simple, and
no noticing that there is some "complicated" attributes exists at all.
That's indeed great characteristic of that *universal* battery class.

For example, ds2760 is not really "simple" monitoring chip. ADC battery
is (it's in -hh tree so far). So, ds2760 is somewhere in between SBS
design, and dumb ADC batteries.

So, my another purposal, which I very like now:
Let's do self-documented properties. current_now, current_avg, e.t.c.
No more just "current", lets remove any ambiguousness!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
