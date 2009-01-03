Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZACUYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZACUYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbZACUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:24:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbZACUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:24:29 -0500
Date: Sat, 3 Jan 2009 12:23:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
cc: Andreas Mohr <andi@lisas.de>, Sriram V <vshrirama@gmail.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
In-Reply-To: <20090102172407.GD1555@ucw.cz>
Message-ID: <alpine.LFD.2.00.0901031217261.3179@localhost.localdomain>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102172407.GD1555@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Jan 2009, Pavel Machek wrote:
> 
> > (or, slightly reworded: I think it's high time for some kernel God to buy a measly
> > netbook or some such instead of 16-core mainframes to get a feeling for the
> > amount of issues that one hits there)
> 
> I have one and yes, its full of problems; see my blog post about 'evil
> little cards'.

Btw, why do people think that CONFIG_USB_PERSIST got removed, and is now 
always on? Exactly because of this issue, and because one kernel God (me) 
wanted to be able to suspend their netbook.

That said, right now most flash performance is so incredibly bad that I 
can't reasonably be expected to use that thing for anything real. They may 
say 15-20 MB/s, but that's best-case streaming performance. Real life 
write performance is often in the tens of kB (yes, *kilo* bytes) per 
second. I hope it will improve, and no, it's not just about ext3 journal 
behavior, although that certainly makes some of the issues much much 
worse.

So no, I don't use my netbook very much. But this _is_ largely fixed ont 
he USB side, even if you may need to do

	echo 1 >/sys/bus/usb/devices/.../power/persist

and I argued that we should default to it for any mounted device. It's 
hard to do, since the device doesn't even know about whether it's mounted 
or not.

			Linus
