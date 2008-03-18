Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYCTLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYCTLVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYCTLVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 07:21:09 -0400
Received: from agminet02.oracle.com ([141.146.126.229]:26141 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbYCTLVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 07:21:08 -0400
Message-ID: <47E026DC.6020603@oracle.com>
Date: Tue, 18 Mar 2008 13:32:28 -0700
From: Randy Dunlap <randy.dunlap@Oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] kernel: add bit rotation helpers for 16 and 8 bit
References: <1205871841.17607.10.camel@brick>
In-Reply-To: <1205871841.17607.10.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Will replace open-coded variants elsewhere.  Done in the same
> style as the 32-bit versions.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, these will be used to replace some open-coded variants in the
> mac80211 code, there are currently no users so it can go in with little
> risk.
> 
> Randy, CC'd in case I screwed up the kerneldoc.

Looks good.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


>  include/linux/bitops.h |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index 69c1edb..40d5473 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -65,6 +65,46 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
>  	return (word >> shift) | (word << (32 - shift));
>  }
>  
> +/**
> + * rol16 - rotate a 16-bit value left
> + * @word: value to rotate
> + * @shift: bits to roll
> + */
> +static inline __u16 rol16(__u16 word, unsigned int shift)
> +{
> +	return (word << shift) | (word >> (16 - shift));
> +}
> +
> +/**
> + * ror16 - rotate a 16-bit value right
> + * @word: value to rotate
> + * @shift: bits to roll
> + */
> +static inline __u16 ror16(__u16 word, unsigned int shift)
> +{
> +	return (word >> shift) | (word << (16 - shift));
> +}
> +
> +/**
> + * rol8 - rotate an 8-bit value left
> + * @word: value to rotate
> + * @shift: bits to roll
> + */
> +static inline __u8 rol8(__u8 word, unsigned int shift)
> +{
> +	return (word << shift) | (word >> (8 - shift));
> +}
> +
> +/**
> + * ror8 - rotate an 8-bit value right
> + * @word: value to rotate
> + * @shift: bits to roll
> + */
> +static inline __u8 ror8(__u8 word, unsigned int shift)
> +{
> +	return (word >> shift) | (word << (8 - shift));
> +}
> +
>  static inline unsigned fls_long(unsigned long l)
>  {
>  	if (sizeof(l) == 4)


-- 
~Randy
