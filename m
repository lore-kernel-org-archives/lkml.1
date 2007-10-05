Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbXJEHcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbXJEHcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXJEHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:32:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXJEHcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:32:39 -0400
Date: Fri, 5 Oct 2007 09:32:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@jikos.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: video resume stuff
Message-ID: <20071005073238.GA19065@atrey.karlin.mff.cuni.cz>
References: <20071004130513.GA16076@elf.ucw.cz> <470511A9.4060705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470511A9.4060705@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >I'm thinking about how to clean up video resume/how to get it to work
> >for non-VESA video modes (jikos' case).
> >
> >I guess the cleanest solution would be to just call set_mode from
> >wakeup.S.... but that is not as easy as I imagined, because bootup
> >code seems to be compiled separately.
> >
> >Is there some easy way to retain bootup code in memory, so that wakeup
> >can use it? Or is there some easy solution I'm missing?
> 
> No, not really.  The setup code is not even part of the kernel binary 
> proper, and may not even have been run under certain circumstances.
> 
> The "easy" solution is to link it in again, which seems to be what 
> you're doing.  Now, currently the boot code is compiled after vmlinux is 
> complete, so some of the build ordering would have to be changed and/or 
> some of the code rearranged.

I guess major change is to rename conflicting symbols, so that it is
possible to link it twice. That would mean boot_memset() instead of
memset() etc... Is that acceptable?

> I suggest we tackle this *after* the x86 merge.

Well, we still have the regression on jikos' strange system, and I
would like to understand what is going on there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
