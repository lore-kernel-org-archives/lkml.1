Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYEMOsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYEMOsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYEMOr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:47:56 -0400
Received: from ns2.protei.ru ([195.239.28.26]:54387 "EHLO mail.protei.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYEMOrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:47:55 -0400
Message-ID: <4829A9D6.70106@protei.ru>
Date: Tue, 13 May 2008 18:46:46 +0400
From: Nickolay Vinogradov <nickolay@protei.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
References: <481E076A.8060302@protei.ru>   <1210677433.22341.1252875863@webmail.messagingengine.com>   <48298990.7040705@protei.ru>   <1210685053.13437.1252892061@webmail.messagingengine.com>   <20080513135839.GA19291@flint.arm.linux.org.uk> <1210688644.25548.1252907593@webmail.messagingengine.com>
In-Reply-To: <1210688644.25548.1252907593@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexander van Heukelum пишет:

>> No.  "fls" is for finding the last set bit in an _int_.  It is not
>> supposed to have random crap passed to it, such as types longer than
>> sizeof(int).
>>
>> If you're going to pass long long (64-bit) arguments to fls, and then
>> cast them to a u32, you're truncating the value, and you'll get the
>> wrong answer if bit 33 or greater is set.  If you don't actually care
>> about the upper bits, don't pass a 64-bit quantity to fls().
>>
>> If you want to use fls with a long long, use fls64 instead.  Or for top
>> marks, use a u64 and fls64.
> 
> But that was the problem we began with: the generic fls64 passes an u64
> to fls. Nickolay's original patch solves that by putting a cast to u32
> in fls64. I did not, however, understand why the cast was needed.

The cast was needed because fls is a macro, not a function.

-- 
Nickolay Vinogradov
Protei Research and Development Center
St.Petersburg, 194044, Russia
Tel.: +7 812 449 47 27
