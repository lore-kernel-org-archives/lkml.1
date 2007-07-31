Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbXGaOnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbXGaOnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXGaOnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:43:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:45104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbXGaOnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:43:39 -0400
Date: Tue, 31 Jul 2007 16:43:34 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, suspend-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [rft] Kill junk from s2ram resume paths
Message-ID: <20070731144334.GC6973@suse.de>
References: <20070731121246.GF2087@elf.ucw.cz> <200707311520.28003.rjw@sisk.pl> <20070731131814.GI2087@elf.ucw.cz> <200707311549.54863.rjw@sisk.pl> <20070731140140.GJ2087@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070731140140.GJ2087@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha7, Kernel 2.6.22.1-10-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 04:01:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > >  # Running in *copy* of this code, somewhere in low 1MB.
> > > > >  
> > > > > -	movb	$0xa1, %al	;  outb %al, $0x80
> > > > 
> > > > Well, what was this for?
> > > 
> > > Debugging leds on port 80. I still have that card somewhere
> > > :-). Interesting parties can reinsert it.
> > 
> > Ah, I see.
> > 
> > Hmm, can you please write about that in the chanelog more explicitly?
> > Or just comment it out with a "uncomment this to get ..." text?
> 
> I still need someone with x86-64 to test it for me before I submit it
> properly ;-). Updated patch follows.

Compiling right now.

> 								Pavel
> 
> diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> index 1415da1..9cebef7 100644
> --- a/arch/i386/kernel/acpi/wakeup.S
> +++ b/arch/i386/kernel/acpi/wakeup.S
> @@ -28,21 +28,6 @@ #define BEEP \
>  	movb	$15, %al; 	\
>  	outb	%al, $66;
>  
> -#define BEEP \
> -	inb	$97, %al; 	\
> -	outb	%al, $0x80; 	\
> -	movb	$3, %al; 	\
> -	outb	%al, $97; 	\
> -	outb	%al, $0x80; 	\
> -	movb	$-74, %al; 	\
> -	outb	%al, $67; 	\
> -	outb	%al, $0x80; 	\
> -	movb	$-119, %al; 	\
> -	outb	%al, $66; 	\
> -	outb	%al, $0x80; 	\
> -	movb	$15, %al; 	\
> -	outb	%al, $66;
> -
>  ALIGN
>  	.align	4096
>  ENTRY(wakeup_start)

This hunk rejected for me (against 2.6.23-rc1), but i'm testing x86_64, so
it did not matter ;-)
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
