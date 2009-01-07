Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbZAGFMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbZAGFMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZAGFM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:12:27 -0500
Received: from relais.videotron.ca ([24.201.245.36]:42242 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZAGFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:12:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 07 Jan 2009 00:12:21 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: powerpc: introduce asm/swab.h
In-reply-to: <alpine.LFD.2.00.0901062103390.3057@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0901070011240.26118@xanadu.home>
References: <200901070400.n0740Ore002063@hera.kernel.org>
 <1231303340.14860.61.camel@pasglop> <1231303722.14442.1.camel@brick>
 <alpine.LFD.2.00.0901062354030.26118@xanadu.home>
 <alpine.LFD.2.00.0901062103390.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Linus Torvalds wrote:

> 
> 
> On Tue, 6 Jan 2009, Nicolas Pitre wrote:
> > 
> > Well, this series breaks ARM as well:
> 
> Ahh. I think it's the __SWAB_64_THRU_32__ case that is broken. 
> 
> Does this fix things? Totally untested. Of course.

Yep.


> 
> 		Linus
> ---
>  include/linux/swab.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/swab.h b/include/linux/swab.h
> index 9a2d33e..be5284d 100644
> --- a/include/linux/swab.h
> +++ b/include/linux/swab.h
> @@ -68,7 +68,7 @@ static inline __attribute_const__ __u64 __fswab64(__u64 val)
>  #elif defined(__SWAB_64_THRU_32__)
>  	__u32 h = val >> 32;
>  	__u32 l = val & ((1ULL << 32) - 1);
> -	return (((__u64)___swab32(l)) << 32) | ((__u64)(___swab32(h)));
> +	return (((__u64)__fswab32(l)) << 32) | ((__u64)(__fswab32(h)));
>  #else
>  	return ___constant_swab64(val);
>  #endif
> 
