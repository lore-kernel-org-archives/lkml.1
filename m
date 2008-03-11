Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYCKSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYCKSIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYCKSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:08:39 -0400
Received: from gherkin.frus.com ([192.158.254.49]:53230 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbYCKSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:08:38 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D6A28C.4060804@keyaccess.nl> "from Rene Herman at Mar 11, 2008
 04:17:32 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Tue, 11 Mar 2008 13:08:31 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080311180831.8CE90DBA3@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> This is behaviour consistent with the IRQ being dead ...
>
> I suppose it used to work and I suppose the behaviour 
> you are describing above is 100% repeatable?

I can't tell you exactly *when* it used to work, or even *if* it did
with 2.6 kernels.  I'll try to explain...

Sometime back in the 2.6.14 to 2.6.16 timeframe there was an issue with
the ALSA driver not recognizing interrupts (causing looping).  Tyson
Whitehead had put together a patch for the interrupt problem that worked
for him, but not for me or Michael.  One workaround back then was using
the snd-sb8 driver that supports only one DMA channel (half-duplex
operation) anyway: that was a reliable workaround, and may be what I'm
remembering for the "it used to work" case.  I can't find any reliable
evidence that I've *ever* been able to use the ES1888 with its proper
driver under ALSA with 2.6 kernels.  As far as Tyson's patch, I know
he reported it upstream to the ALSA developers, but I saw no followup
communication from either Tyson or the developers.

> Given that you can use aplay -- probably no difference with "aplay -M" ?

I'll give it a shot.

> To get to the bottom of this we might need to get a specific failed version 
> (for readers, it's not been verified that this is a regression since 2.6.24) 
> but we can try to get lucky first.

I'm beginning to think this is *not* a regression, but merely a long-
standing ALSA issue that was never addressed.  I would be fine with
reclassifying this as an ALSA bug and dropping linux-kernel from the
discussion.

> Okay. (tests) seem to at least confirm it's not the 16-bit DMA.

As far as how to proceed from here, I'm certain things were broken in
2.6.1[4-6].  I could try various later releases between .16 and .24 to
see if snd-es18xx worked for any of those, but I think the answer will
be "no."  I think a useful test would be to see if "snd-sb8" works in
2.6.25-rcX, which would at least narrow things down a bit.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
