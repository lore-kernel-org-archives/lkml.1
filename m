Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbYKSHo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYKSHo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKSHot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:44:49 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:59141 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYKSHos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:44:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DsTVrAzM44qHfBS8jFwLCEWME9DWWA6oPDOXg4Lydob0KFGujktO4SSh5s2pjtVLXG
         LQUE5kye7BimR+SYbOdmvVPCmruiQqclxVtfff4c0lZx1tANQFIr7bBVk9ToKJ62UOPr
         IosyUvQfvc3ATqYZcqk1VKseanqHoDnlxUd0o=
Message-ID: <386072610811182344p50f5d644qe6d415fe0bc5a017@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:44:47 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin header files and machine common code
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Graf Yang" <graf.yang@analog.com>
In-Reply-To: <200811191805.07656.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <1226999108-13839-3-git-send-email-cooloney@kernel.org>
	 <20081118225629.eddd23ae.akpm@linux-foundation.org>
	 <200811191805.07656.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: e541f7dcab3f8bad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 3:05 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Wednesday 19 November 2008 17:56, Andrew Morton wrote:
>> On Tue, 18 Nov 2008 17:05:05 +0800 Bryan Wu <cooloney@kernel.org> wrote:
>
>> > +#define smp_mb__before_clear_bit() barrier()
>> > +#define smp_mb__after_clear_bit()  barrier()
>> > +
>> > +static inline void __set_bit(int nr, volatile unsigned long *addr)
>> > +{
>> > +   int *a = (int *)addr;
>> > +   int mask;
>> > +
>> > +   a += nr >> 5;
>> > +   mask = 1 << (nr & 0x1f);
>> > +   *a |= mask;
>> > +}
>> > +
>> > +static inline void __clear_bit(int nr, volatile unsigned long *addr)
>> > +{
>> > +   int *a = (int *)addr;
>> > +   int mask;
>> > +
>> > +   a += nr >> 5;
>> > +   mask = 1 << (nr & 0x1f);
>> > +   *a &= ~mask;
>> > +}
>> > +
>> > +static inline void __change_bit(int nr, volatile unsigned long *addr)
>> > +{
>> > +   int mask;
>> > +   unsigned long *ADDR = (unsigned long *)addr;
>> > +
>> > +   ADDR += nr >> 5;
>> > +   mask = 1 << (nr & 31);
>> > +   *ADDR ^= mask;
>> > +}
>>
>> I'm surprised there isn't any generic code which can be used for the above.
>
> include/asm-generic/bitops/non-atomic.h
>
>
>> > ...
>>
>> Gad what a lot of code.  I don't think I have time to read it all, sorry.
>
> :) I don't know who is expected to. Cc'ing linux-arch for something
> like this might attract some helpful comments.

Yeah, I posted it to linux-arch.
Thanks
-Bryan
