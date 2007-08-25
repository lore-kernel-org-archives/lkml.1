Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbXHYT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbXHYT0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934449AbXHYT0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:26:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:56160 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934458AbXHYT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:26:07 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+595EwUNS599806VMFc0cgKU+RtZf+ZJM6/IVxo6
	Zfc/dRZMsYey0h
Date: Sat, 25 Aug 2007 21:26:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Boyer <jwboyer@gmail.com>
cc: Casey Dahlin <cjdahlin@ncsu.edu>, linux-kernel@vger.kernel.org
Subject: Re: USB Key light on/off state depending on mount
In-Reply-To: <625fc13d0708241413s1086527id377b49e7adacc5e@mail.gmail.com>
Message-ID: <Pine.LNX.4.60.0708252116580.3809@poirot.grange>
References: <46CF468E.1080607@ncsu.edu> <625fc13d0708241413s1086527id377b49e7adacc5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Josh Boyer wrote:

> On 8/24/07, Casey Dahlin <cjdahlin@ncsu.edu> wrote:
> > Most USB keys nowadays have a small LED somewhere inside of them that
> > lights up when they are plugged in. On a windows box, the key is lit up
> > whenever it is mounted, and as soon as it is unmounted it turns off,
> > giving a handy physical indicator that the key is safe to remove. On
> > linux, the light is simply on whenever the key is plugged in.
> >
> > Should linux toggle the light depending on mount state? Is it as trivial
> > as it seems or does this reflect some larger issue?
> 
> I think that depends on the key.  My Corsair keys have the light
> flicker whenever I/O is on-going.

Yeah, it does, I am not a big expert in USB storage, and I haven't seen 
many USB sticks, but I might imagine how windows turns the LED off on 
unmount. Try "eject /dev/sdX", where sdX is your USB storage, after you 
unmount it. Be careful, especially if you have SATA (or SCSI) discs in 
your system or if you use libata for PATA discs not to eject the wrong 
one... For example, if you think you have to eject /dev/sdc, check before 
ejecting it with "mount" if there are any /dev/sdc* partitions mounted.

As for LED going on only when mounting, don't know. Maybe they also issue 
eject after initial enumeration? In which case the LED would go shortly on 
on plug in, then off, then on again on mount. You can try it under Linux 
too, if you issue eject after plugging in but before mount. I think, you 
won't be able to mount it directly after ejecting, you'd have to force 
re-enumeration under Linux.

Thanks
Guennadi
---
Guennadi Liakhovetski
