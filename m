Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZDWT5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZDWT5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDWT5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:57:24 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:20220 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZDWT5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:57:23 -0400
Message-ID: <49F0C817.8050407@caviumnetworks.com>
Date: Thu, 23 Apr 2009 12:57:11 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2009 19:57:12.0369 (UTC) FILETIME=[B158EA10:01C9C44D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> A boolean single_bit_set() routine would simplify the numerous
> constructs of the form (((n & (n - 1)) == 0)) when testing for
> single-bitness.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
> This is similar to the current is_power_of_2() routine defined in
> include/linux/log2.h, which is mathematically identical but,
> semantically, should be defined independently just so the code is more
> readable.
> 
> I'm open to an alternative function name.
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index 6182913..1c0c840 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -45,6 +45,13 @@ static inline unsigned long hweight_long(unsigned long w)
>  	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
>  }
> 
> +static inline __attribute__((const))
> +bool single_bit_set(unsigned long n)
> +{
> +        return (n != 0 && ((n & (n - 1)) == 0));
> +}
> +
> +


It would be nice to be able to override this per architecture.

For example a more efficient implementation on CPUs that have a 
population count instruction (__builtin_popcountl()) might be:

static inline __attribute__((const))
bool singe_bit_set(unsigned long n)
{
	return __builtin_popcountl(n) == 1;
}


Also, are we still putting 'inline' everywhere?

David Daney


