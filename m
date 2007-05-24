Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXEXSHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXEXSHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXEXSHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:07:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44634 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbXEXSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:07:11 -0400
Date: Thu, 24 May 2007 20:07:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Rob Landley <rob@landley.net>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070524180704.GE4470@stusta.de>
References: <200705231510.52932.rob@landley.net> <20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com> <200705241347.43727.rob@landley.net> <adahcq26r8p.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adahcq26r8p.fsf@cisco.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 10:55:34AM -0700, Roland Dreier wrote:
>  > And if you #include a non-inlined definition in two .c files, the compiler 
>  > will emit two copies into two separate .o files.  What you're hoping is that 
>  > the linker will notice they're identical and merge them, and last I checked I 
>  > couldn't even reliably get it to do that with constant strings.
> 
> No, I don't care if the linker merges it or not.  In fact I hope that
> maybe the compiler is smart enough to optimize the function for the
> sites it's called from in a particular .c file.
> 
> But a function defined in a .h file had better be static, so it
> shouldn't matter if there are two copies of it in the final linked
> image (any more than it matters if there are 100 inlined copies of it).

The problem is that inline functions in headers are intended to be 
called from different C files.

gcc might not inline it in the C files where it is called more than 
once.

But it will always inline it if it's called only once.

One of both will be suboptimal, but from gcc's perspective it was 
optimal.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

