Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXGBXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXGBXSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXGBXSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:18:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50532 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756613AbXGBXSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:18:48 -0400
Date: Tue, 3 Jul 2007 01:18:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070702231837.GB9071@elf.ucw.cz>
References: <20070701125035.3f54d8b0@oldman> <200707020159.51200.ak@suse.de> <20070702105000.73e50500@freepuppy.localdomain.hemminger.net> <200707022108.43293.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707022108.43293.ak@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The patch makes sense. You don't need to poll every jiffie to find
> > out if system has panic.
> 
> The blink driver doesn't run on panic (or at least not on panic on
> the same kernel). It runs always. It was designed to do the blinking
> while the kdump kernel runs and writes the dump.
> 
> > But I agree with Linus, it is the kind 
> > of patch that doesn't belong in the mainline kernel.  Every developer
> > seems to have built up a set of crappy/fragile debug tools, but these
> > don't belong in the wild.
> 
> Would you argue then that kdump also doesn't belong into the kernel?
> The patch was designed to plug a hole in kdump (no visual feedback) 


   kexec -p <dump-capture-kernel-vmlinux-image> \
   --initrd=<initrd-for-dump-capture-kernel> --args-linux \
   --append="root=<root-dev> <arch-specific-options>"

....so we are already using initrd for dumping...? I'd say providing
visual feedback is surely an userspace task.

Heck, with the keyboard leds you could probably blink them in a way
telling user how much dump was done. Blink once then pause - 10%,
blink twice then pause - 20%, ...

And yes, we already have LED subsystem capable of doing all this.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
