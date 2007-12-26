Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbXLZUtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbXLZUtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXLZUtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:49:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38386 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638AbXLZUtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:49:45 -0500
Date: Wed, 26 Dec 2007 21:49:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>, security@kernel.org
Cc: "David P. Reed" <dpreed@reed.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071226204925.GF8094@elf.ucw.cz>
References: <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com> <20071216094029.GD27280@elte.hu> <47659BF3.4040100@zytor.com> <4765AF78.60307@reed.com> <20071216232353.GC5692@elf.ucw.cz> <4765B622.8030507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765B622.8030507@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-16 15:34:58, H. Peter Anvin wrote:
> Pavel Machek wrote:
>> Hi!
>>> The process of safely making delicate changes here is beyond my 
>>> responsibility as just a user - believe me, I'm not suggesting that a 
>>> risky fix be put in .24.   I can patch my own kernels, and I can even 
>>> share an unofficial patch with others for now, or suggest that Fedora and 
>>> Ubuntu add it to their downstream.
>>>
>>> May I make a small suggestion, though.   If the decision is a DMI-keyed 
>>> switch from out-80 to udelay(2)  gets put in, perhaps there should also 
>>> be a way for people to test their own configuration for the underlying 
>>> problem made available as a script.   Though it is a "hack", all you need 
>>> to freeze a problem system is to run a loop doing about 1000 "cat 
>>> /dev/nvram > /dev/null"  commands.  If that leads to a freeze, one might 
>>> ask to have the motherboard added to the DMI-key list.
>> Can you freeze it by catting /dev/rtc, too? That may be significant,
>> because that is readable for group audio (at least on some
>> systems)... which would smell like "small security hole" to me.
>
> Heck, on my system (Fedora 7), it's mode 644...

Ok, time to CC security team, I'd say.

Problem is, that some AMD64x2 nVidia laptops crash on port 0x80
access... which is easily user-triggerable by using /dev/rtc. If it is
644 on Fedora, I guess we have a problem.

Otoh, it is "only" a denial of service, and it can probably be
attributed to "buggy hardware". Is that still relevant for security team?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
