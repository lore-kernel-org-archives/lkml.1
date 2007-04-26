Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbXDZXMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbXDZXMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXDZXMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:12:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52081 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755187AbXDZXMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:12:38 -0400
Date: Fri, 27 Apr 2007 01:12:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Lang <david.lang@digitalinsight.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070426231228.GI21695@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <20070426224256.GB21926@elf.ucw.cz> <Pine.LNX.4.63.0704261520350.9674@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704261520350.9674@qynat.qvtvafvgr.pbz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >This is basically the loop above, made complex by the fact that we do
> >not want to have separate partition for snapshot; we just want to
> >reuse free space in swap partition.
> 
> with the size of drives today is it really that bad to require a seperate 
> partition for this?

Yes. You want uswsusp to work in situations where swsusp worked.

> I also don't like the idea of storing this in the swap partition for a 
> couple of reasons.
> 
> 1. on many modern linux systems the swap partition is not large enough.
> 
> for example, on my boxes with 16G or ram I only allocate 2G of swap
> space

WTF? So allocate larger swap partition. You just told me disks are big
enough.

> 2. it's too easy for other things to stomp on your swap partition.
> 
>   for example: booting from a live CD that finds and uses swap
> partitions

That's a feature. If you are booting from live CD, you _want_ to erase
any hibernation image.

> if you are needing space for your freeze, allocate it in an unabigous way, 
> not by re-useing an existing partition.

Of course you have that option. Writing image is done in userspace, so
you are free to write it to raw partition (and first versions indeed
done that).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
