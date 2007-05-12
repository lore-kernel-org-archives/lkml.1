Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbXELMXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbXELMXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 08:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbXELMXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 08:23:17 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:40794 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285AbXELMXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 08:23:16 -0400
Date: Sat, 12 May 2007 14:21:37 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Message-ID: <20070512122137.GA25944@mailshack.com>
References: <464158E9.2000207@zytor.com> <1178806235.18785.1189115515@webmail.messagingengine.com> <46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com> <4643A128.30302@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4643A128.30302@zytor.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Sat, 12 May 2007 14:23:05 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.3.1.53; VDF: 6.38.1.19; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:48:08PM -0700, H. Peter Anvin wrote:
> > It doesn't probe the hardware in dangerous ways. (Search for mode_scan
> > in video.S) It works by trying to set a mode via the normal
> > AH=0/AL=mode/int 0x10 method for all possible values of mode. It then
> > checks if the bios reports the new mode as being set and reads a few
> > standard vga registers to determine if it is a text mode. It's
> > completely independent of the CONFIG_VIDEO_SVGA stuff.
> 
> It's dangerous, all right (which is why it doesn't do it by default),
> since you have no guarantee that the BIOS doesn't totally vomit on these
> calls -- or, like my laptop, take about a minute before giving up
> finding nothing.

I see. I think I just have too much trust in the biosses. Anyhow, the
'scan' option has always taken quite a bit of time, usually between 30
seconds and a minute.

> Anyway, I re-implemented scanning and pushed it out to the git tree;
> please try it out as it does absolutely nothing on any of my machines.

I can confirm that it works for at least one computer over here (a six
months old x86_64 machine with ATI ES1000-based on-board graphics). Some
non-vesa modes including a nice 100x30 one with 8x16 font are found by
the 'scan' option. No 100x60, however, but that is not a regression.

> > I thought the 32-bit jump was required to come before the segment loads.
> > Does this code load values from the gdt, or are they just loaded as real
> > mode segments? As long as it does not crash it does not matter, because
> > head.S reloads them again.
> 
> Once CR0.PE is set, segments are loaded from the GDT.

I believe you :).

Greetings,
	Alexander
