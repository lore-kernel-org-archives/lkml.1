Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbXEXR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbXEXR5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbXEXR5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:57:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44631 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750747AbXEXR5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:57:17 -0400
Date: Thu, 24 May 2007 19:57:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070524175710.GD4470@stusta.de>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de> <ada7iqz9qlj.fsf@cisco.com> <20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ada3b1m87pa.fsf@cisco.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 10:14:41AM -0700, Roland Dreier wrote:
>  > A function only belongs into a header file if we always want it inlined, 
>  > otherwise it belongs into a C file.
> 
> Again, why?  Why don't we trust the compiler to decide if a function
> should be inlined or not, even if the definition happens to be in a .h
> file?
> 
> It seems like a perfectly valid optimization for the compiler to only
> emit code once for a function and then call it where it is used, even
> if that function happens to be defined in a .h file.

The compiler will always inline it when it's called once from a C file, 
and it might not inline it there when it's called more than once from 
another C file. So in the end, we have it not only out-of-line but also 
inlined in several places.

Functions in header files should either be extremely short so that 
inlining them makes sense, or always optimize to something extremely 
short after being inlined.

If it's an optimization to emit the code only once, then it's a bug that 
it's in a header file.

>  - R.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

