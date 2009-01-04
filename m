Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZADCPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZADCPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZADCO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:14:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZADCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:14:56 -0500
Message-ID: <49601B94.3060408@zytor.com>
Date: Sat, 03 Jan 2009 18:14:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
In-Reply-To: <200901032006.47652.rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
>> The new patches have *more* environmental
>> dependencies than that ever did.
> 
> Could you please be a little more specific?
> 

In this case, you're assuming that every version of every shell this is
going to get involved with is going to do math correctly with the
requisite precision, which is nowhere guaranteed, I'm pretty sure.

>> Third, if someone actually cares to do it right, I have a smallish
>> bignum library at http://git.zytor.com/?p=lib/pbn.git;a=summary that
>> might be a starting point.
> 
> This doesn't _need_ bignum support.  It maxes out around 72 bits and the 
> _result_ can't use more than about $SHIFT bits because you're dividing by the 
> amount you shifted, so just chop off the bottom 32 bits, do a normal 64 bit 
> division on the top (it has to fit), and then do the same division on the 
> appropriate shifted remainder, and combine the results.  This is easy because 
> when the shift _is_ 32 bits or more, the bottom 32 bits all have to be zeroes 
> so you don't even have to mask and add, just shift the remainder left 32 bits 
> so you can continue the divide.
> 
> Pulling out perl isn't always a good alternative to thinking about the 
> problem.
> 

Neither is open-coding a bignum operation instead of relying on an
existing, validated implementation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

