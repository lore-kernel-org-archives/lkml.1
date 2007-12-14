Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbXLNVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbXLNVF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXLNVFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:05:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57804 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754329AbXLNVFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:05:19 -0500
Date: Fri, 14 Dec 2007 22:05:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071214210532.GA28793@elf.ucw.cz>
References: <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <476250D5.8000409@gmail.com> <20071214142355.GA10130@elte.hu> <476294D3.4060609@keyaccess.nl> <20071214144628.GA16074@elte.hu> <476299B7.8030908@keyaccess.nl> <20071214183626.4a16e2af@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214183626.4a16e2af@the-village.bc.nu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-14 18:36:26, Alan Cox wrote:
> > > i dont think this should matter: old systems that truly _need_ the ISA 
> > > delay will be slow enough to not trip up. (nor are they really affected 
> > > by these early delays - the delays were more for crappy ISA devices that 
> > > get initialized later down, when the delay loop is already calibrated)
> > 
> > 8253 (DMAC) and 8254 (PIT) have been reported in earlier versions of the 
> > thread. By Alan, I believe.
> 
> They've been seen to be problems up to PII era machines. I'm not aware of
> any newer than that with this problem. We also don't need to touch the
> DMAC that early anyway that I can see - just the PIT.
> 
> In fact if we have a fast processor we have a TSC and APIC so we don't
> need the PIT ?

It is still good to be able to disable APIC/TSC. Neither are
particulary reliable time sources.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
