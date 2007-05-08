Return-Path: <linux-kernel-owner+w=401wt.eu-S966359AbXEHQ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966359AbXEHQ7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966061AbXEHQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:59:40 -0400
Received: from khc.piap.pl ([195.187.100.11]:34265 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965884AbXEHQ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:59:38 -0400
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.3 - QMGR
References: <m3abwhcy74.fsf@maximus.localdomain>
	<m3vef5biob.fsf@maximus.localdomain>
	<5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk>
	<m3hcqoa772.fsf@maximus.localdomain>
	<86D26EBE-5899-468F-9C79-23E83E0DE04B@cam.ac.uk>
	<m33b289zku.fsf@maximus.localdomain>
	<m31whs5ehn.fsf_-_@maximus.localdomain>
	<20070508113232.GA32055@xi.wantstofly.org>
	<m3k5vj76bi.fsf@maximus.localdomain>
	<20070508144001.GC387@xi.wantstofly.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 18:59:36 +0200
In-Reply-To: <20070508144001.GC387@xi.wantstofly.org> (Lennert Buytenhek's message of "Tue, 8 May 2007 16:40:01 +0200")
Message-ID: <m3ps5b5k07.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek <buytenh@wantstofly.org> writes:

> See for example arch/arm/mach-ep93xx/core.c, handling of the A/B/F
> port GPIO interrupts.
>
> In a nutshell, it goes like this.

Thanks, I will investigate.

>> There may be up to 6 Ethernet ports (not sure about hardware
>> status, not yet supported even by Intel) - 7 queues * 128 entries
>> each = ~ 3.5 KB. Add 2 long queues (RX) for HSS and something
>> for TX, and then crypto, and maybe other things.
>
> You're unlikely to be using all of those at the same time, though.

That's the point.

> And what do you do if the user does compile all of these features into
> his kernel and then tries to use them all at the same time?  Return
> -ENOMEM?

If he is able to do so, yes - there is nothing we can do. But
I suspect a single machine would not have all possible hardware.
The problem is, we don't know what would it have, so it must be
dynamic.

> Shouldn't we make sure that at least the features that are compiled in
> can be used at the same time?

We can't - hardware capabilities limit that. A general purpose
distribution would probably want to compile in everything (perhaps
as modules).

>  If you want that guarantee, then you
> might as well determine the SRAM map at compile time.

That would be most limiting with IMHO no visible advantage.
-- 
Krzysztof Halasa
