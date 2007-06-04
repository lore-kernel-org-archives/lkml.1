Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbXFDLtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbXFDLtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXFDLs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:48:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53211 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753229AbXFDLs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:48:57 -0400
Date: Mon, 4 Jun 2007 13:49:00 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH] Fix roundup_pow_of_two(1)
Message-ID: <20070604114900.GS5500@stusta.de>
References: <200705172356.57620.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200705172356.57620.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 11:56:56PM +0200, Rolf Eike Beer wrote:
> Fix roundup_pow_of_two(1)
> 
> 1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It does
> in case the argument is a variable but in case it's a constant it behaves
> wrong and returns 0. Probably nobody ever did it so this was never noticed.

I'm not getting the problem.
2^0 = 1

> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> 
> ---
> commit 01ceeffac83011f0b5021013cc4abd1c4f291df5
> tree 7da59df51617d7cebd55e4361019181645a17e10
> parent ab35916f807eb4f2019a208e96cb0bddbb91dfc3
> author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 17 May 2007 23:43:54 +0200
> committer Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 17 May 2007 23:43:54 +0200
> 
>  include/linux/log2.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 57e641e..1b8a2c1 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -159,7 +159,7 @@ unsigned long __roundup_pow_of_two(unsigned long n)
>  #define roundup_pow_of_two(n)			\
>  (						\
>  	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 0 :			\
> +		(n == 1) ? 1 :			\
>  		(1UL << (ilog2((n) - 1) + 1))	\
>  				   ) :		\
>  	__roundup_pow_of_two(n)			\

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

