Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXFDQOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXFDQOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXFDQOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:14:47 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50894 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbXFDQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:14:46 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Date: Mon, 4 Jun 2007 12:14:37 -0400
User-Agent: KMail/1.9.6
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
References: <1180971378.6313.72.camel@localhost.localdomain>
In-Reply-To: <1180971378.6313.72.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041214.38017.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 11:36:18 Richard Purdie wrote:
> The following series contains several patches which I'm hoping could see
> some testing in -mm. They're all been seen before at some point. The LZO
> ones are important due to the dependent patches, the swap write failure
> ones have just fallen off the radar.
>
> LZO
> ===
>
> We've seen a lot of activity in attempts to rewrite this in a
> CodingStyle compatible 'clean' kernel style. The last update I read has
> convinced me this is not ready for kernel usage at this time,
> particularly due to the memory alignment issues.

I have been involved in benchmarking and testing that stripped down and 
kernel-style version and cannot recall any mention of said alignment errors. 
Perhaps I was removed from the CC: list - could you point me at them?

At last glance the other version you mention has a marginally faster (1 to 
3%) "safe" decompressor. The only problems that Markus FXJ Oberhumer seems to 
have with that stripped down version is the renaming of the 
LZO1X_MEM_COMPRESS constant to LZO1X_WORKMEM_SIZE.  (only real complaint I 
can recall seeing).

If there *are* memory alignment issues, why not fix them in that tiny code 
rather than pushing a different version of the code into the kernel that is 
1) Not kernel style and 2) bloated?

> I would like to see a version merged in the next merge window so other
> patches depending on it can follow. If a better LZO implementation is
> eventually sorted out, it can replace the lzo core in due course, the
> API will be interchangeable.

I do agree that an implementation of LZO should go in the kernel so that the 
various users of the algorithm don't have to include their own copies of the 
code. However, the sheer bloatworthiness of this code is pitiful - perhaps 
it'd be best if you ditched the "diffability against userspace" in favor of 
having the code be non-bloated and kernel-style? (wait - that's what 
the "other" version you previously mentioned does)

> I've trimmed my patch down to only contain the "safe" decompression
> function, pruned the headers a little further and merged in the cleanup
> patch I submitted to -mm previously. I've also included an updated
> version of the patch to make resier4 use the shared LZO functions
> (fixing a security hole in the process).

Then submit the fix for the security hole as a seperate patch to the Rieser4 
people.

> Swap Write Failures
> ===================
>
> Currently write failures to swap are handled badly and these patches
> allow more graceful handling.
>
> These have been looked at before by various people and have no known
> issues I'm aware of. I don't think Hugh has time to review these so if
> anyone else familiar with the appropriate code area could look over
> them, I'd appreciate it.


Unless you can clearly point out those "memory alignment" issues in the 
kernel-style code of the other LZO implementation that was posted as an RFC I 
have to say this: stop the FUD. 

Anyway... It may mean absolutely nothing but...

NACK

DRH
