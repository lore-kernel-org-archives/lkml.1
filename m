Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYDAIrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYDAIrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYDAIra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:47:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39114 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYDAIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:47:29 -0400
Date: Tue, 1 Apr 2008 10:47:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit,
	convert i386
Message-ID: <20080401084710.GB4787@elte.hu>
References: <20080331171506.GA24017@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331171506.GA24017@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Generic versions of __find_first_bit and __find_first_zero_bit are 
> introduced as simplified versions of __find_next_bit and 
> __find_next_zero_bit. Their compilation and use are guarded by a new 
> config variable GENERIC_FIND_FIRST_BIT.
> 
> The generic versions of find_first_bit and find_first_zero_bit are 
> implemented in terms of the newly introduced __find_first_bit and 
> __find_first_zero_bit.
> 
> This patch also converts i386 to the generic functions. The text size 
> shrinks slightly due to uninlining of the find_*_bit functions.
> 
>    text    data     bss     dec     hex filename
> 4764939  480324  622592 5867855  59894f vmlinux  (i386 defconfig before)
> 4764645  480324  622592 5867561  598829 vmlinux  (i386 defconfig after)
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
> 
> Hi Ingo,
> 
> Here is another step in the unification of the bitops for i386 and 
> x86_64. This patch implements a minimal conversion to a generic 
> implementation of find_first_bit/find_first_zero_bit for i386. The 
> optimization for small bitmaps and the conversion of x86_64 will 
> follow soon.
> 
> Compiles and runs fine on i386 and x86_64 (current x86#testing).

thanks, applied.

I guess we should keep the bitops.h portions alive for the moment though 
(surrounded by #ifndef GENERIC_FIND_FIRST_BIT), to make it easy for 
anyone to flip the Kconfig bit around via a oneliner patch and do some 
benchmarking? At least initially - i'm convinced that we want the 
generic versions in the long run. (especially if, as your patches do it, 
the generic code picks up the easy constant tests and optimizes them at 
build time)

	Ingo
