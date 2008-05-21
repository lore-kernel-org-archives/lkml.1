Return-Path: <linux-kernel-owner+w=401wt.eu-S932982AbYEUKFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbYEUKFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbYEUKEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:04:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952AbYEUKEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:04:45 -0400
Subject: Re: [PATCH] consolidate all within() implementations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4832F14B.2060305@de.ibm.com>
References: <48313E23.4030104@de.ibm.com>	<1211230216.5915.90.camel@brick>
	 <48328700.4000907@googlemail.com>
	 <20080520024535.6b4f487e.akpm@linux-foundation.org>
	 <4832F14B.2060305@de.ibm.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 12:04:26 +0200
Message-Id: <1211364266.6463.76.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  /**
> + * addr_within - check whether address is in start-and-end address range
> + * @addr: address
> + * @start: start address (included in range)
> + * @end: end address (excluded from range)
> + */
> +static inline int addr_within(const void *addr, const void *start,
> +			      const void *end)
> +{
> +	return ((unsigned long) addr >= (unsigned long) start) &&
> +	       ((unsigned long) addr < (unsigned long) end);
> +}
> +
> +/**
> + * addr_within_len - check whether address is in start-and-length address range
> + * @addr: address
> + * @start: start of range
> + * @len: number of bytes in range
> + */
> +static inline int addr_within_len(const void *addr, const void *start,
> +				  size_t len)
> +{
> +	return ((unsigned long) addr >= (unsigned long) start) &&
> +	       ((unsigned long) addr < ((unsigned long) start + len));
> +}

might be my braindamage, but I'd have written it like:

static inline int 
addr_within_len(const void *addr, const void *start, size_t len)
{
	return (unsigned long)addr - (unsigned long)start < len;
}

static inline int
addr_within(const void *add, const void *start, const void *end)
{
	return addr_within_len(addr, start, 
			(unsigned long)end - (unsigned long)start);
}


