Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbXCLXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbXCLXM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXCLXM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:12:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49784 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882AbXCLXM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:12:28 -0400
Date: Tue, 13 Mar 2007 00:12:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       alon.barlev@gmail.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
Message-ID: <20070312231220.GC9749@elf.ucw.cz>
References: <20070306181430.GB3151@strauss.suse.de> <20070306182134.GB9491@redhat.com> <20070312104352.GA4313@ucw.cz> <20070312205513.GC21835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312205513.GC21835@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > >  > +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
>  > > 
>  > > Why a long? It's unlikely that someone is going to have a command line
>  > > bigger than 0xffff.
>  > 
>  > Well, I could imagine overflowing that. Describing your numa setup,
>  > excluding few bad bits of ram using memmap=exact, set up your boot
>  > over iscsi on cmdline.... these are likely to eat insane ammount of
>  > cmdline space.
> 
> 65535 characters? Are you for real?
> Stop and think about just how big that is. If you have to create
> a boot command line that long, you have serious, serious issues.

Well, it is about the same size as my .config...

I agree we are unlikely to hit it any time soon... I could imagine
some (ab)uses, like fixed_acpi_bios=<lots of hex digits>, but those
are ugly. I could also imagine some uses where entire embedded machine
is described at kernel commandline.

Yes, all those are ugly/unlikely. OTOH saving 2 bytes does not seem
like that great goal.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
