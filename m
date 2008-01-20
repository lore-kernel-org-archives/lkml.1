Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbYATGzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbYATGzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 01:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYATGz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 01:55:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:33025 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYATGz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 01:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EbvOtNeaawSHEXm+Q0GXMMtyC/BjzTzavB6ggP1duf1ZBFtoeCPeW7u1vAkPDvLBWJSi5qTukCJy8fO2uMFD2Q2GieezV9HpzvxTC5X/9z17bIJwud9B6o4GCfivuDJrdH6nw7x6qZR/ZoVsPU8fJeIPXJ4K9AJGjG70rUCYgRU=
Message-ID: <86802c440801192255t3181d4cav7c55fee2b246f356@mail.gmail.com>
Date: Sat, 19 Jan 2008 22:55:25 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: disable_mtrr_trim only need for x86_64
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4792DE0C.9060906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <4792DE0C.9060906@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 19, 2008 9:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
> > [PATCH] x86: disable_mtrr_trim only need for x86_64
> >
> > mtrr_trim_uncached_memory is only used in x86_64,
> >
> > so disable_mtrr_trim is not needed for x86_32
> >
> > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>
> That seems like a bug, and if so this patch goes the wrong direction.
> (If the 32-bit code has another solution for the same problem, they
> should be unified.)
>
> The trimming of uncachable memory affects both 32- and 64-bit kernels;
> it's the same hardware, and even 32-bit kernels (with PAE) can access
> memory above 4 GB.
>

the trim fix for x86_64 is update end_pfn, and use that as max_pfn,
and max_low_pfn in setup_arch.

but i386 is setup_arch is only using max_low_pfn.

to make you happy, the simple way is update e820 table so code could
be unified between i386 and x86_64

update the e820 table by checking mtrr like checking gart hole...

is that OK?

YH
