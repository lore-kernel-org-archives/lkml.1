Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXD0VZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXD0VZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXD0VZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:25:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbXD0VZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:25:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 23:26:58 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <20070427124932.GA23513@elf.ucw.cz>
In-Reply-To: <20070427124932.GA23513@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704272326.58964.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 14:49, Pavel Machek wrote:
> Hi!
> 
> > > * Doing things in the right order? (Prepare the image, then do the
> > > atomic copy, then save).
> > 
> > I'd actually like to discuss this a bit..
> > 
> > I'm obviously not a huge fan of the whole user/kernel level split and 
> > interfaces, but I actually do think that there is *one* split that makes 
> > sense:
> > 
> >  - generate the (whole) snapshot image entirely inside the kernel
> > 
> >  - do nothing else (ie no IO at all), and just export it as a single image 
> >    to user space (literally just mapping the pages into user space). 
> >    *one* interface. None of the "pretty UI update" crap. Just a single 
> >    system call:
> > 
> > 	void *snapshot_system(u32 *size);
> > 
> >    which will map in the snapshot, return the mapped address and the size 
> >    (and if you want to support snapshots > 4GB, be my guest, but I suspect 
> >    you're actually *better* off just admitting that if you cannot shrink 
> >    the snapshot to less than 32 bits, it's not worth doing)
> 
> I think this is very similar to current uswsusp design; except that we
> are using read on /dev/snapshot to read the snapshot (not memory
> mapping) and that we freeze the system

Yes, it seems so.

> (because I do not think killall _SIGSTOP is enough).

Agreed.

Greetings,
Rafael
