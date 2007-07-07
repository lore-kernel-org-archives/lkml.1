Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXGGNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXGGNXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXGGNXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 09:23:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65211 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753652AbXGGNXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 09:23:07 -0400
Date: Sat, 7 Jul 2007 15:23:39 +0200
From: Carlo Wood <carlo@alinoe.com>
To: William Pitcock <nenolod@atheme-project.org>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070707132339.GA1631@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	William Pitcock <nenolod@atheme-project.org>,
	Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0707070220440.20167@osiris.atheme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707070220440.20167@osiris.atheme.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 02:41:05AM +0000, William Pitcock wrote:
> The most fucked up thing that I can think of about the current state of 
> affairs in ALSA is dmix. Every other UNIX sound system like ALSA does it's 
> software mixing in kernel space. The applications never even know about 
> it. It's not only until recently (2005-2006 or so) that ALSA came close to 
> this, but there are still problems. Many cards need workarounds to make 
> dmix work because of the way it works, and the way that ALSA buffers data 
> around.

I have to agree. I am not an audio programmer, just a user; but the
bottom line is simply: It is WAY to hard to get things working (if
at all possible).
At one point I tried to get sound from xmms and ut2004 at the same time
(on my new machine). I was ASTONISHED that it didn't Just-Work!
After trying many complex things-- I gave up and put my old
soundblaster Live! in the new PC - because that card has hardware
support for this. Now I was lucky to HAVE that other soundcard,
but what about all those other users out there who just buy a new
PC, with a sound chip on the motherboard and then, being simple, ordinairy
users, have to face this ALSA configuration hell to do something
as simple as having two audio applications play sound at the same time?

> For the non-technically inclined, ALSA only keeps two fragments for 
> input/output data each. This is horribly unusable because most soundcard 
> fragments are only 1KB, so applications have to adopt ringbuffers to pass 
> data to ALSA. If you're doing video, this leads to possible timing issues 
> unless you sit down and well design your abstraction layer for audio I/O.

Worse-- the two fragment limit is passed on to the OSS emulation (or at least
it was in 2005; but if this is still true for the ALSA API in 2007, then my
guess is that it's also still true for the OSS emulation). The result is
that applications written for OSS do not work anymore when using the OSS
emulation of ALSA and therefore the argument of providing backwards
compatibility doesn't exist.

...snip...
> Hannu has ideas on how that could work. I suggest all of the kernel 
> developers listen, and listen well, or this mess will never be fixed in a 
> way that is truly usable.
> 
>   -nenolod

Good post, nenolod.

-- 
Carlo Wood <carlo@alinoe.com>

PS I am NOT saying that I want ALSA to be removed from the kernel.
   I am just saying that I agree with those who think that the
   ALSA API is too complex, hard to use and has serious flaws that
   should be addressed.

