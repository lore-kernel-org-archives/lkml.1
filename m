Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYKTNvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYKTNvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYKTNuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:50:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:60218 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYKTNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:50:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bmql+JRO4qwDOcQwPS8t7HE3xux7j25DLtPD2i65V1gP8WeazF/vUgZA6kl1j83ZI6
         x6/OBgxcJFHE/+a7+JbEtcZ0UnMW/bPovI1avJvC6bfMn5ZFlkR+KDh50g43yq8zz3Fd
         yJ55WIO2P74/KWpdwiY8TcFvF78L+fkByljI8=
Message-ID: <8bd0f97a0811200550o6bde2024k76f9cf2dd7aed384@mail.gmail.com>
Date: Thu, 20 Nov 2008 08:50:50 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin header files and machine common code
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Graf Yang" <graf.yang@analog.com>
In-Reply-To: <386072610811182342i701497bcne37e6ab0dbefbc5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <1226999108-13839-3-git-send-email-cooloney@kernel.org>
	 <20081118225629.eddd23ae.akpm@linux-foundation.org>
	 <386072610811182342i701497bcne37e6ab0dbefbc5f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 02:42, Bryan Wu wrote:
> On Wed, Nov 19, 2008 at 2:56 PM, Andrew Morton wrote:
>> On Tue, 18 Nov 2008 17:05:05 +0800 Bryan Wu wrote:
>>> From: Graf Yang <graf.yang@analog.com>
>>> +#define smp_mb__before_clear_bit()   barrier()
>>> +#define smp_mb__after_clear_bit()    barrier()
>>> +
>>> +static inline void __set_bit(int nr, volatile unsigned long *addr)
>>> +{
>>> +     int *a = (int *)addr;
>>> +     int mask;
>>> +
>>> +     a += nr >> 5;
>>> +     mask = 1 << (nr & 0x1f);
>>> +     *a |= mask;
>>> +}
>>> +
>>> +static inline void __clear_bit(int nr, volatile unsigned long *addr)
>>> +{
>>> +     int *a = (int *)addr;
>>> +     int mask;
>>> +
>>> +     a += nr >> 5;
>>> +     mask = 1 << (nr & 0x1f);
>>> +     *a &= ~mask;
>>> +}
>>> +
>>> +static inline void __change_bit(int nr, volatile unsigned long *addr)
>>> +{
>>> +     int mask;
>>> +     unsigned long *ADDR = (unsigned long *)addr;
>>> +
>>> +     ADDR += nr >> 5;
>>> +     mask = 1 << (nr & 31);
>>> +     *ADDR ^= mask;
>>> +}
>>
>> I'm surprised there isn't any generic code which can be used for the above.
>>
>
> As Nick said, include/asm-generic/bitops/non-atomic.h is the generic code.
> We will try it.

the Blackfin ISA provides explicit bit operations.  is there something
special about these C-level bit operations that prevents us from using
them ?

PRM:
"BITCLR" on page 13-2
"BITSET" on page 13-4
"BITTGL" on page 13-6
-mike
