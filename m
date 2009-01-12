Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZALFYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZALFYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZALFXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:23:48 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:60828 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZALFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:23:48 -0500
Message-ID: <31014a580901112123w43ceb2eaobe7b6952f1c00717@mail.gmail.com>
Date: Sun, 11 Jan 2009 23:23:46 -0600
From: "Mark A. Miller" <mark@mirell.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Cc: "Bernd Petrovitsch" <bernd@firmix.at>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "Rob Landley" <rob@landley.net>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <496AD0E9.2020909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net>
	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	 <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
	 <20090104030619.GA21466@linux-sh.org>
	 <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
	 <1231677939.3517.5.camel@gimli.at.home>
	 <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
	 <496AD0E9.2020909@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 11:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Mark A. Miller wrote:
>>
>> Actually, something that has amused me during this discussion, is that
>> right now, the latest stable Perl (5.8.8) does not compile correctly
>> on a uclibc host...
>>
>
> The latest stable Perl is 5.10.0, and the latest of the 5.8 series is 5.8.9.
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.


My mistake. However,
http://perl5.git.perl.org/perl.git/blob_plain/HEAD:/hints/linux.sh
still has the issue, specifically:

if test -L /lib/libc.so.6; then
    libc=`ls -l /lib/libc.so.6 | awk '{print $NF}'`
    libc=/lib/$libc
fi

So, my version was incorrect, yet the problem still exists. I've got a
patch, need to submit it, yet Perl *does not compile* on a uclibc
target *as is*.

And this is why we should avoid adding new tools to build the kernel,
because they introduce yet more break points, as such.

Thanks.

-- 
Mark A. Miller
mark@mirell.org

"My greatest strength, I guess it would be my humility. My greatest
weakness, it's possible that I'm a little too awesome" - Barack Obama
