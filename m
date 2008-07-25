Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbYGYQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbYGYQG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYGYQGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:06:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYGYQGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:06:50 -0400
Message-ID: <4889FA03.6010708@zytor.com>
Date: Fri, 25 Jul 2008 12:06:27 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce lower_32_bits() macro
References: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> The file kernel.h contains the upper_32_bits macro. This patch adds the other
> part, the lower_32_bits macro. Its first use will be in the driver for AMD
> IOMMU.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  include/linux/kernel.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index f9cd7a5..6fd2977 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -73,6 +73,12 @@ extern const char linux_proc_banner[];
>   */
>  #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
>  
> +/**
> + * lower_32_bits - return bits 0-31 of a number
> + * @n: the number we're accessing
> + */
> +#define lower_32_bits(n) ((n) & 0xffffffffULL)
> +

NAK.  These are assymmetric with regards to type, which is the *last* 
thing we want.

The symmetric definition would be ((u32)(n)), but that's already 
idiomatic use, so why not use it as-is?

	-hpa

