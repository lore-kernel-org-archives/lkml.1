Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZADCoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZADCoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZADCoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:44:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZADCoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:44:03 -0500
Message-ID: <49602248.1010506@zytor.com>
Date: Sat, 03 Jan 2009 18:43:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Rob Landley <rob@landley.net>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net> <20090104023609.GA20929@shareable.org> <4960215F.8040804@zytor.com>
In-Reply-To: <4960215F.8040804@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jamie Lokier wrote:
>> Related query:
>>
>> Does the Perl script being replaced use 64-bit arithmetic?  Because
>> many Perl installations only do 32-bit arithmetic.
>>
>> If the Perl version works in 32-bit arithmetic, why does the shell
>> version not do the same thing?
>>
> 
> The Perl version uses Math::BigInt, a Perl standard module (with a
> canned-values fallback for ancient or minimal Perl installations) to do
> arbitrary precision arithmetic.
> 
> The original version also produced constants that could be used with
> 64-bit values, but since gcc doesn't support 128-bit arithmetic on
> 32-bit platforms (gcc *does* support 128-bit arithmetic on 64-bit
> platforms) we didn't end up using it and removed them, although the code
> to generate them can still be activated.
> 

I should point out that we really *should* use same kind of techniques
on 64 bits as well.  Even though the likelihood of overflow is much less
there (and the use of the LCD reduces it further) it is nonzero.
However, the places that were most seriously affected were all operating
on 32-bit input (int), and therefore the overflow-free 64-bit code never
got written.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

