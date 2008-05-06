Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbYEFWkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbYEFWkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYEFWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:40:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYEFWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:40:17 -0400
Date: Tue, 6 May 2008 19:39:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506193928.5acfc84d@gaivota>
In-Reply-To: <4820C3D8.6040403@s5r6.in-berlin.de>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
	<20080504160904.GF19717@sgi.com>
	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
	<200805060902.25835.alistair@devzero.co.uk>
	<20080506073134.424780a3@gaivota>
	<48206C73.80509@s5r6.in-berlin.de>
	<20080506161346.183f367c@gaivota>
	<4820B524.5080100@s5r6.in-berlin.de>
	<20080506170623.53732e78@gaivota>
	<4820C3D8.6040403@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 22:47:20 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mauro Carvalho Chehab wrote:
> > For example, if you have a em28xx device with msp3400 and tvp5150 and another
> > em28xx device with saa7113.
> > 
> > If you remove the select's for MSP3400, TVP5150 and SAA7113, at, em28xx, the
> > module will compile without problems.
> > 
> > The only issue is that you won't be able to see any images (due to the lack of
> > tvp5150 or saa7113 analog TV demoduler) or listen to the audio, if the device
> > needs msp3400 to decode audio.
> [...]
> > It is much better for the user to just select EM28XX and let the Kconfig do the
> > hard work of selecting what low-level driver applies for em28xx-based devices.
> > 
> > This causes lots of select, being very hard to maintain. The better would be to
> > have a select-like clause that could check the dependencies automatically.
> > 
> > Another alternative would be some sort of script (checkpatch.pl?) that would
> > check if all selected dependencies are ok.
> 
> Ah, now I understand.  You use "select" to enable options which aren't 
> actually a build requirement for the selecting option.

Yes. That's why there are so many selects. Just a few of them are really to
select "real" build requirements.

> Another workaround for this UI limitation:
> 
> config VIDEO_EM28XX
> 	tristate "Empia EM2800/2820/2840 USB video capture support"
> 	depends on WHATEVER_BUILD_REQUIREMENT_IS_LEFT
> 	select MAYBE_ANOTHER_BUILD_REQUIREMENT
> 	help
> 	  ...
> 
> comment "Empia EM28xx devices may require Philips SAA7113/4/5 video 
> decoders"
> 	depends on VIDEO_EM28XX && VIDEO_SAA711X=n
> 
> comment "Empia EM28xx devices may require Texas Instruments TVP5150 
> video decoder"
> 	depends on VIDEO_EM28XX && VIDEO_TVP5150=n
> 
> Still awkward, but now you don't have to copy VIDEO_SAA711X's and 
> VIDEO_TVP5150's dependencies to VIDEO_EM28XX anymore.

This seems Interesting, but probably not very effective, since it would produce
a large amount of "warnings". However, we may use something like this:

comment "WARNING: Empia EM28xx devices require a video decoder"
 	depends on VIDEO_EM28XX && (VIDEO_TVP5150=n && VIDEO_SAA711X = n)

> 
> 
> Or another idea:
> 
> Copy _all_ dependencies of drivers which can be selected by "...if 
> VIDEO_HELPER_CHIPS_AUTO" to VIDEO_HELPER_CHIPS_AUTO.

I actually did this for tuners, on this changeset (still not at mainstream):
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=d10b3c6817fb3fed8e6cd6d64d47c187a615c952

> 
> Of course all these issues go away as soon as somebody has implemented 
> "select" with recursive dependency check.

Yes.

Cheers,
Mauro
