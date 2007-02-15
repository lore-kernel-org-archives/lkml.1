Return-Path: <linux-kernel-owner+w=401wt.eu-S1161277AbXBOVEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161277AbXBOVEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161280AbXBOVEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:04:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:50981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161277AbXBOVEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:04:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling =?iso-8859-15?q?updated=09patch?=
Date: Thu, 15 Feb 2007 22:03:59 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <200702151537.51202.arnd@arndb.de> <1171570918.31179.36.camel@dyn9047021078.beaverton.ibm.com>
In-Reply-To: <1171570918.31179.36.camel@dyn9047021078.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702152203.59902.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+/cwRYT61ijBa1kf+ciJ8925nhkrfGZwYfPre8nXS4YV2eZx09u7Qc3b6lvKTks3rVK27RO8moELGckX/2CvUnCeex8V1h/+wwsf1JJ9WIWA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 21:21, Carl Love wrote:

> I have done some quick measurements.  The above method limits the loop
> to at most 2^16 iterations.  Based on running the algorithm in user
> space, it takes about 3ms of computation time to do the loop 2^16 times.
> 
> At the vary least, we need to put the resched in say every 10,000
> iterations which would be about every 0.5ms.  Should we do a resched
> more often?  

Yes, just to be on the safe side, I'd suggest to do it every 1000
iterations.
 
> Additionally we could up the size of the table to 512 which would reduce
> the maximum time to about 1.5ms.  What do people think about increasing
> the table size?

No, that won't help too much. I'd say 256 or 128 entries is the most
we should have.

> As for using a logarithmic spacing of the precomputed values, this
> approach means that the space between the precomputed values at the high
> end would be much larger then 2^14, assuming 256 precomputed values.
> That means it could take much longer then 3ms to get the needed LFSR
> value for a large N.  By evenly spacing the precomputed values, we can
> ensure that for all N it will take less then 3ms to get the value.
> Personally, I am more comfortable with a hard limit on the compute time
> then a variable time that could get much bigger then the 1ms threshold
> that Arnd wants for resched.  Any thoughts?

When using precomputed values on a logarithmic scale, I'd recommend
just rounding to the closest value and accepting the relative inaccuracy,
instead of using the precomputed value as the base and then calculating
from there.

	Arnd <><
