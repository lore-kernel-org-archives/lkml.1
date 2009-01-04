Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZADCgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZADCgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZADCgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:36:23 -0500
Received: from mail2.shareable.org ([80.68.89.115]:59246 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZADCgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:36:22 -0500
Date: Sun, 4 Jan 2009 02:36:09 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090104023609.GA20929@shareable.org>
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901032006.47652.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> This doesn't _need_ bignum support.  It maxes out around 72 bits and
> the _result_ can't use more than about $SHIFT bits because you're
> dividing by the amount you shifted, so just chop off the bottom 32
> bits, do a normal 64 bit division on the top (it has to fit), and
> then do the same division on the appropriate shifted remainder, and
> combine the results.  This is easy because when the shift _is_ 32
> bits or more, the bottom 32 bits all have to be zeroes so you don't
> even have to mask and add, just shift the remainder left 32 bits so
> you can continue the divide.
> 
> Pulling out perl isn't always a good alternative to thinking about
> the problem.

Related query:

Does the Perl script being replaced use 64-bit arithmetic?  Because
many Perl installations only do 32-bit arithmetic.

If the Perl version works in 32-bit arithmetic, why does the shell
version not do the same thing?

-- Jamie
