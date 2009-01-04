Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZADRxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZADRxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZADRxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:53:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbZADRxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:53:32 -0500
Date: Sun, 4 Jan 2009 09:53:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@suse.cz>, Andreas Mohr <andi@lisas.de>,
       Sriram V <vshrirama@gmail.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
In-Reply-To: <20090104120415.33e32c6b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0901040946280.3179@localhost.localdomain>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102172407.GD1555@ucw.cz> <alpine.LFD.2.00.0901031217261.3179@localhost.localdomain> <20090103204329.GD1666@elf.ucw.cz>
 <20090103204535.1a91cbcb@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0901031306150.3179@localhost.localdomain> <20090103231013.3591d027@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0901031854320.3179@localhost.localdomain> <20090104120415.33e32c6b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Jan 2009, Alan Cox wrote:
> 
> The distribution question is 'how do you make that decision reliably and
> correctly ?'. That is closely followed by 'what state should it end up in
> if the relevant scripts don't run for some reason ?' - which is clearly
> "not persistent" for safety reasons.

No.

You clearly haven't even read my emails. I quote:

  And yes, the "sane defaults" may well be that FATFS does _not_ make the 
  media be persistent.

however, the sane default remains that things like / and /home _should_ be 
marked persistent.


> I was simply pointing out that
> 
> - the general distribution default cannot be one that harms user data on
> music players

No you were not. You were repeatign that mantra as if it was relevant, 
when it isn't.

> - that you can fix it more elegantly by quiescing and validating file
> systems across a suspend/resume

Send me a patch. 

Hint: you can't sanely even validate it without teaching the USB layer 
_not_ to disconnect and re-connect the damn thing on resume (ie set the 
"persistent" flag), because that can easily cause totally unrelated 
changes to cause the device to be re-enumerated. How do you even find it? 

In other words, you're wrong. 

The only sane thing to do is what I already outlined: teach the 
mount-points (and yes, on a per-mount-point basis) to mark the devices 
persistent, and make the device drivers honor that.

Then, in _addition_, you can - once the device stays around - you can also 
add a filesystem callback for suspend/resume, and make the filesystem try 
to do extra sanity checking. 

But quite frankly, that's very much the secondary stage, since it won't 
matter in any sane real situation (ie once you've simply said that "we 
don't cae about FAT being persistent"). And it's a secondary stage also 
simply because it needs to happen _after_ you've already made the ones you 
care about persistent, since it simply won't work otherwise.

			Linus
