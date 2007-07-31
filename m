Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXGaNl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXGaNl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbXGaNlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:41:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbXGaNlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:41:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] Kill junk from s2ram resume paths
Date: Tue, 31 Jul 2007 15:49:54 +0200
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>,
       suspend-devel@lists.sourceforge.net, seife@suse.de
References: <20070731121246.GF2087@elf.ucw.cz> <200707311520.28003.rjw@sisk.pl> <20070731131814.GI2087@elf.ucw.cz>
In-Reply-To: <20070731131814.GI2087@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311549.54863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 31 July 2007 15:18, Pavel Machek wrote:
> Hi!
> 
> > > This removes some stale debugging infrastructure from s2ram
> > > paths. Also, there's no need to verify_cpu on x86-64 -- cpu can't
> > > change during s2ram, and removed #if 0-ed code. Some testing would be
> > > useful, perpahs it will even fix someone's machine :-). (VGA accesses
> > > could theoretically hurt if vga is not present / if it is in some
> > > strange state).
> > > 
> > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > > 
> > > diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> > > index 1415da1..9719bd6 100644
> > > --- a/arch/i386/kernel/acpi/wakeup.S
> > > +++ b/arch/i386/kernel/acpi/wakeup.S
> > > @@ -53,9 +38,6 @@ wakeup_code:
> > >  # Uncomment this to make your computer start producing ugly noise as soon
> > >  # as BIOS returns to this real-mode entry point.
> > >  #	BEEP
> > > - 	movw	$0xb800, %ax
> > > -	movw	%ax,%fs
> > > -	movw	$0x0e00 + 'L', %fs:(0x10)
> > 
> > Hmm, was this a part of that yellow "Linux" string?
> 
> Yes. But I'm afraid that may cause problems if vga is not ready.

I agree.

> > >  # Running in *copy* of this code, somewhere in low 1MB.
> > >  
> > > -	movb	$0xa1, %al	;  outb %al, $0x80
> > 
> > Well, what was this for?
> 
> Debugging leds on port 80. I still have that card somewhere
> :-). Interesting parties can reinsert it.

Ah, I see.

Hmm, can you please write about that in the chanelog more explicitly?
Or just comment it out with a "uncomment this to get ..." text?

> > > @@ -88,8 +82,6 @@ # Running in *copy* of this code, somewh
> > >  	movw	%ax,%fs
> > >  	movw	$0x0e00 + 'L', %fs:(0x10)
> > 
> > Why aren't you removing this line?
> 
> Mistake, killed.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
