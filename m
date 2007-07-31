Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbXGaOzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbXGaOzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762647AbXGaOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:55:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762444AbXGaOzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:55:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: [rft] Kill junk from s2ram resume paths
Date: Tue, 31 Jul 2007 17:03:43 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, suspend-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070731121246.GF2087@elf.ucw.cz> <20070731140140.GJ2087@elf.ucw.cz> <20070731144334.GC6973@suse.de>
In-Reply-To: <20070731144334.GC6973@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311703.44096.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 31 July 2007 16:43, Stefan Seyfried wrote:
> On Tue, Jul 31, 2007 at 04:01:40PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > > >  # Running in *copy* of this code, somewhere in low 1MB.
> > > > > >  
> > > > > > -	movb	$0xa1, %al	;  outb %al, $0x80
> > > > > 
> > > > > Well, what was this for?
> > > > 
> > > > Debugging leds on port 80. I still have that card somewhere
> > > > :-). Interesting parties can reinsert it.
> > > 
> > > Ah, I see.
> > > 
> > > Hmm, can you please write about that in the chanelog more explicitly?
> > > Or just comment it out with a "uncomment this to get ..." text?
> > 
> > I still need someone with x86-64 to test it for me before I submit it
> > properly ;-). Updated patch follows.
> 
> Compiling right now.
> 
> > 								Pavel
> > 
> > diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> > index 1415da1..9cebef7 100644
> > --- a/arch/i386/kernel/acpi/wakeup.S
> > +++ b/arch/i386/kernel/acpi/wakeup.S
> > @@ -28,21 +28,6 @@ #define BEEP \
> >  	movb	$15, %al; 	\
> >  	outb	%al, $66;
> >  
> > -#define BEEP \
> > -	inb	$97, %al; 	\
> > -	outb	%al, $0x80; 	\
> > -	movb	$3, %al; 	\
> > -	outb	%al, $97; 	\
> > -	outb	%al, $0x80; 	\
> > -	movb	$-74, %al; 	\
> > -	outb	%al, $67; 	\
> > -	outb	%al, $0x80; 	\
> > -	movb	$-119, %al; 	\
> > -	outb	%al, $66; 	\
> > -	outb	%al, $0x80; 	\
> > -	movb	$15, %al; 	\
> > -	outb	%al, $66;
> > -
> >  ALIGN
> >  	.align	4096
> >  ENTRY(wakeup_start)
> 
> This hunk rejected for me (against 2.6.23-rc1), but i'm testing x86_64, so
> it did not matter ;-)

I think it's gone in favor of the more sophisticated beeping support.
