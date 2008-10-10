Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYJJF0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYJJF0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYJJF0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:26:12 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:4755 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYJJF0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:26:11 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 01:26:11 EDT
Message-ID: <48EEE546.9070405@zankel.net>
Date: Thu, 09 Oct 2008 22:16:54 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Bob Wilson <bwilson@tensilica.com>
Subject: Re: [PATCH 3/4] xtensa: Change unaligned access to use packed struct
 implementation
References: <1223447904.8195.67.camel@brick>
In-Reply-To: <1223447904.8195.67.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Please allow me a couple of days to look into it. I don't know the 
historic reasons why the memmove variant was chosen.

Thanks,
-Chris


Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> There are only 3 arches that use the memmove-based implementation, there
> doesn't seem to be any obvious reason not to use the struct implementation.
> 
> Chris?
> 
>  include/asm-xtensa/unaligned.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-xtensa/unaligned.h b/include/asm-xtensa/unaligned.h
> index 8f3424f..1a242b2 100644
> --- a/include/asm-xtensa/unaligned.h
> +++ b/include/asm-xtensa/unaligned.h
> @@ -11,13 +11,13 @@
>  #define _ASM_XTENSA_UNALIGNED_H
>  
>  #ifdef __XTENSA_EL__
> -# include <linux/unaligned/le_memmove.h>
> +# include <linux/unaligned/le_struct.h>
>  # include <linux/unaligned/be_byteshift.h>
>  # include <linux/unaligned/generic.h>
>  # define get_unaligned	__get_unaligned_le
>  # define put_unaligned	__put_unaligned_le
>  #elif defined(__XTENSA_EB__)
> -# include <linux/unaligned/be_memmove.h>
> +# include <linux/unaligned/be_struct.h>
>  # include <linux/unaligned/le_byteshift.h>
>  # include <linux/unaligned/generic.h>
>  # define get_unaligned	__get_unaligned_be

