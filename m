Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbXGaNST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbXGaNST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXGaNSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:18:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39913 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759464AbXGaNSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:18:07 -0400
Date: Tue, 31 Jul 2007 15:18:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       suspend-devel@lists.sourceforge.net, seife@suse.de
Subject: Re: [rft] Kill junk from s2ram resume paths
Message-ID: <20070731131814.GI2087@elf.ucw.cz>
References: <20070731121246.GF2087@elf.ucw.cz> <200707311520.28003.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707311520.28003.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This removes some stale debugging infrastructure from s2ram
> > paths. Also, there's no need to verify_cpu on x86-64 -- cpu can't
> > change during s2ram, and removed #if 0-ed code. Some testing would be
> > useful, perpahs it will even fix someone's machine :-). (VGA accesses
> > could theoretically hurt if vga is not present / if it is in some
> > strange state).
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> > index 1415da1..9719bd6 100644
> > --- a/arch/i386/kernel/acpi/wakeup.S
> > +++ b/arch/i386/kernel/acpi/wakeup.S
> > @@ -53,9 +38,6 @@ wakeup_code:
> >  # Uncomment this to make your computer start producing ugly noise as soon
> >  # as BIOS returns to this real-mode entry point.
> >  #	BEEP
> > - 	movw	$0xb800, %ax
> > -	movw	%ax,%fs
> > -	movw	$0x0e00 + 'L', %fs:(0x10)
> 
> Hmm, was this a part of that yellow "Linux" string?

Yes. But I'm afraid that may cause problems if vga is not ready.

> >  # Running in *copy* of this code, somewhere in low 1MB.
> >  
> > -	movb	$0xa1, %al	;  outb %al, $0x80
> 
> Well, what was this for?

Debugging leds on port 80. I still have that card somewhere
:-). Interesting parties can reinsert it.

> > @@ -88,8 +82,6 @@ # Running in *copy* of this code, somewh
> >  	movw	%ax,%fs
> >  	movw	$0x0e00 + 'L', %fs:(0x10)
> 
> Why aren't you removing this line?

Mistake, killed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
