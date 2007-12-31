Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbXLaMNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbXLaMNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbXLaMNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:13:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50515 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764AbXLaMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:13:32 -0500
Date: Mon, 31 Dec 2007 13:11:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231131107.GA26339@ucw.cz>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu> <4777C6E8.7060202@keyaccess.nl> <20071230170612.GA16502@elte.hu> <20071230182937.40f2adcf@the-village.bc.nu> <20071230204650.GA26120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230204650.GA26120@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-30 21:46:50, Ingo Molnar wrote:
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > So the current plan is to go with an io_delay=udelay default in v2.6.25, 
> > > to give this a migration window, and io_delay=none in v2.6.26 [and a 
> > > complete removal of arch/x86/kernel/io_delay.c], once the _p() uses are 
> > > fixed up. This is gradual enough to notice any regressions we care about 
> > > and also makes it nicely bisectable and gradual.
> > 
> > You will break systems if you blindly go around disabling _p delays 
> > for ISA and LPC bus devices. The DEC Hinote laptops for example are 
> > well known for requiring the correct ISA and other keyboard controller 
> > delays. I don't expect anyone to test with a hinote or see it until it 
> > hits Debian or similar 'low resource' friendly devices.
> 
> well, using io_delay=udelay is not 'blindly disabling'. io_delay=none 
> would be the end goal, once all _p() API uses are eliminated by 
> transformation. In drivers/ alone that's more than 1000 callsites, so 
> it's quite frequently used, and wont go away overnight.

IOW elimination of broken inb_p()/outb_p() interfaces is the ultimate
goal. Agreed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
