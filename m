Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbXKKQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbXKKQFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXKKQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:05:29 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49493 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754475AbXKKQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:05:28 -0500
Date: Sun, 11 Nov 2007 17:05:04 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071111160504.GR21669@stusta.de>
References: <20071111142205.GO21669@stusta.de> <1701.1194793436@redhat.com> <20071111151951.GP21669@stusta.de> <200711111646.27496.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711111646.27496.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 04:46:26PM +0100, Andi Kleen wrote:
> 
> > My thoughts go more into the direction that we have hundreds of similar
> > cases where e.g. a VFS function might currently only by used by OCFS2
> > and therefore be dead code for most users, and the only maintainable
> > solution will be to solve these at the compiler and/or linker level.
> 
>  -ffunction-sections can mostly do it, but only for non modular kernels
> 
> One problem is that EXPORT_SYMBOL always creates a reference to the function
> even when nothing uses it.
> 
> We would need a weak EXPORT_SYMBOL and some way to check references
> over main kernel and modules. I suppose it could be done as part of modpost
> and then generating a custom linker script that only includes the function
> sections referenced by anybody. But to make this work it would require
> putting all the EXPORT_SYMBOLs into own sections too, but I suppose
> that would be possible.
> 
> In the past we had trouble that the explicit linker scripts mentioning every 
> function section made the linker very slow, but perhaps that's fixed now.

I don't remember the technical details, but Denys Vlasenko posted some 
patches that implemented -ffunction-sections while retaining exports.

Another approach would be calling gcc with "-combine -fwhole-program".

David Woodhouse once sent a whacky patch that implemented this on a 
per-module basis retaining exports.

Much harder, but with the biggest possible savings, would be a 
CONFIG_MODULES=n kernel built with one gcc call.

>...
> The question is if it would be still have a large enough user base without the 
> distribution kernels. If it would be only used by a few users I don't think 
> the maintenance overhead would be worth it.
>...

You forget the big embedded userbase - some even stay at kernel 2.4 
since kernel 2.6 is much bigger.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

