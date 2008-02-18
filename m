Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbYBRXG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbYBRXG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYBRXGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:06:21 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:55075 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYBRXGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:06:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Tue, 19 Feb 2008 00:04:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802182343.12749.mb@bu3sch.de> <20080218225354.GE23181@flint.arm.linux.org.uk>
In-Reply-To: <20080218225354.GE23181@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802190004.47594.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 23:53:54 Russell King wrote:
> I get extremely pissed off everytime I have to try to explain random
> alignment issues to people.  "It doesn't work like i386 so it must be
> broken" is a rediculous position to take.

I did _not_ ask for a general description of alignment. I did
_just_ ask why ARM is special and why the compiler didn't handle
it there. I do develop code for MIPS, so I do know what alignment is about.

> > Can you _please_ explain what makes ARM so special here?
> 
> No because I don't really know.
> 
> > Why can't we have an array of this structure on ARM?
> > 
> > struct ssb_device_id {
> >        __u16   vendor;
> 
> 2 bytes
> 
> >        __u16   coreid;
> 
> 2 bytes
> 
> >        __u8    revision;
> 
> 1 byte
> 
> > };
> 
> and therefore sizeof this structure will be 5 bytes, but because of the
> ABI rules (which are _explicitly_ allowed by the C standard), it'll
> become 8 bytes due to padding afterwards.

So that would be fine. I don't see what would be unaligned then.
Even if it would pad only one byte after the "revision" it would all
be aligned in a natural way.

> At a _guess_ and its only a guess, the linker will enforce this rule
> between compilation units, otherwise the implications are disgusting
> (would probably result in all loads having to be individual byte loads
> and instructions to combine the result - since ARM has strict alignment
> requirements.)

Yeah. As I said. The code does work on MIPS, which has strict alignment
requirements as well.

> What I can say is that the ABI will not be changed because someone in the
> kernel decides they don't like it.  So the options are: either fix it so
> it works, or accept that the code is broken and will never work on ARM.

I did never ask to change some ABI, sorry.
Still I can't see why this structure will cause alignment issues, as the
compiler will pad it up to the right boundary automagically, as you said
above. Why doesn't the ARM compiler do this?

-- 
Greetings Michael.
