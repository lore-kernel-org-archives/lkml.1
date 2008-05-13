Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYEMOfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYEMOfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbYEMOf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:35:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:34783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbYEMOf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:35:28 -0400
From: Andreas Schwab <schwab@suse.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Nickolay Vinogradov <nickolay@protei.ru>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
References: <481E076A.8060302@protei.ru>
	<1210677433.22341.1252875863@webmail.messagingengine.com>
	<48298990.7040705@protei.ru>
	<1210685053.13437.1252892061@webmail.messagingengine.com>
	<20080513135839.GA19291@flint.arm.linux.org.uk>
X-Yow: WHOA!!  I'm having a RELIGIOUS EXPERIENCE right NOW!!
Date: Tue, 13 May 2008 16:35:25 +0200
In-Reply-To: <20080513135839.GA19291@flint.arm.linux.org.uk> (Russell King's
	message of "Tue, 13 May 2008 14:58:39 +0100")
Message-ID: <je7idyw9ua.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> writes:

> On Tue, May 13, 2008 at 03:24:13PM +0200, Alexander van Heukelum wrote:
>> On Tue, 13 May 2008 16:29:04 +0400, "Nickolay Vinogradov"
>> <nickolay@protei.ru> said:
>> > Alexander van Heukelum &#1087;&#1080;&#1096;&#1077;&#1090;:
>> > 
>> > > Hi Nickolay,
>> > > 
>> > > The change is ok, I guess, but the cast should be a no-op (fls
>> > > takes an int, which is always 32 bit in linux). What is the problem
>> > > you are seeing? Does fls64() return a wrong value in some cases? If
>> > > so, what cpu? Which values?
>> > > 
>> > > Why would this be a bug on big endian systems only? There is no
>> > > pointer magic involved, so the compiler should take care of the
>> > > casts in a correct way.
>> > > 
>> > > Maybe you see a compiler warning? Which compiler version?
>> > > 
>> > > (also note that current (development) kernels now have separate
>> > > versions for 32-bit and 64-bit environments.)
>> > 
>> > Because fls() is a macro for asm-arm:
>> > 
>> > #define fls(x) \
>> >          ( __builtin_constant_p(x) ? constant_fls(x) : \
>> >          ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 
>> > 32-__r; }) )
>> > 
>> > We can fix it right here:
>
> No.  "fls" is for finding the last set bit in an _int_.  It is not
> supposed to have random crap passed to it, such as types longer than
> sizeof(int).

If you write fls as an (inline) function then the argument is implicitly
converted.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
