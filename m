Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZAIKLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZAIKLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZAIKLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:11:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42005 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZAIKLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:11:10 -0500
Date: Fri, 9 Jan 2009 11:13:17 +0100
From: Pavel Machek <pavel@suse.cz>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, trenn@suse.de, hmh@hmh.eng.br
Subject: Re: HP accelerometer: free fall detection working, testers wanted
Message-ID: <20090109101317.GC3396@elf.ucw.cz>
References: <20081121212121.GA7222@elf.ucw.cz> <20081128082215.GA2013@elf.ucw.cz> <492FC1D0.2040408@tremplin-utc.net> <20081128104459.GA32417@atrey.karlin.mff.cuni.cz> <493310BD.8050506@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <493310BD.8050506@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-11-30 23:16:29, Éric Piel wrote:
> Pavel Machek schreef:
> > Hi!
> > 
> >>> I got free fall detection to work -- apparently BIOS does all the
> >>> important stuff itself. 
> >>>
> >>> Now... I'd like some testers. (Don't comment on code... yet. Yes, it
> >>> has some issues).
> 
> >> Also, how do you try free fall? Did you try also with the lid
> >> opened?
> > 
> > With the lid opened, too, yes. I just took the machine, then tried to
> > let go and catch it meter below that. (Of course I did not really let
> > go, but released the grip and followed...)
> 
> Hi,
> I've tested it. Mostly, it works. If I let it fall, it detects it. If I
> repeat, it detects it again. If shake it, it doesn't detect any freefall
> (good). However, for this to work on my laptop (2510p), after the device
> is turned on, the AC must be unplugged and lid closed before it starts
> working. It seems that that's only this specific state that triggers the
> configuration of the sensor by the bios. Once setup, I can plug back and
> open again the lid, the sensor keeps detecting the freefalls (until it's
> turned off again).
> 
> So I think it's still necessary to explicitly set up the sensor. It's
> just a matter of setting up the registers as the bios does. We should be
> able to manage (just by dumping them once).

Well, according to HP we should not be setting registers
ourselves. Maybe CLRI method needs to be called or something?

> BTW, there were a couple of problems with the scripts. You have change
> "/dev/misc" to "/dev/freefall" (which I also like more) but forgot to
> update the driver itself.
> 
> For hp3dg, it couldn't find the led (not the same truncation of the name
> of the led). Probably you could replace the name of the led by:
> /sys/class/leds/*hddprotect*/

Yes, the scripts were very very quick hacks.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
