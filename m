Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbYESUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbYESUub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYESUuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:50:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:48505 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYESUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=csjn9DL8viH+S2AAHSgJV6YK1KKO7AkDFysKiz7yN9ySXMmcr3edtVoCBQntt/DAAzZ5yqfeaH+ujCKGnv4C6i2R11yDOIJUNpp6RZ7rk738X2TE+BCmUmO/3H5r/ECmwUCjhS2rCYFseujIkoOyweGBeOe2mZpEZHU778+ixc4=
Subject: Re: [PATCH] consolidate all within() implementations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
In-Reply-To: <48313E23.4030104@de.ibm.com>
References: <48313E23.4030104@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 May 2008 13:50:16 -0700
Message-Id: <1211230216.5915.90.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 10:45 +0200, Peter Oberparleiter wrote:
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> This patch consolidates a number of different implementations of the
> within() function which checks whether an address is within a specified
> address range. Apart from parameter typing, existing implementations can
> be classified in two categories which differ in the way the range is
> specified:
> 
>   1) by start and end address
>   2) by start and size
> 
> These categories are covered by the within() macro (case 1) and the
> within_len() macro (case 2). Both macros can be used with any pointer
> or pointer-equivalent type as parameter.

Would it be that hard to just make them static inlines taking unsigned
longs?

> 
> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> ---
>  
>  /**
> + * within - check whether address is within a start-and-end address range
> + * @val: address

@addr perhaps

> + * @start: start address (included in range)
> + * @end: end address (excluded from range)
> + */
> +#define within(val, start, end) ({			\

How about:
static inline int addr_within(unsigned long addr, unsigned long start,
			      unsigned long end)

> +	unsigned long __val = (unsigned long) (val);	\
> +	unsigned long __start = (unsigned long) (start);	\
> +	unsigned long __end = (unsigned long) (end);	\
> +	(__val >= __start) && (__val < __end); })
> +
> +/**
> + * within_len - check whether address is within a start-and-length address range
> + * @val: address

@addr
> + * @start: start of range
> + * @len: number of bytes in range
> + */
> +#define within_len(val, start, len) ({				\
﻿static inline int addr_within_len(unsigned long addr, unsigned long start,
				  unsigned long len)

Just a thought.

Harvey

