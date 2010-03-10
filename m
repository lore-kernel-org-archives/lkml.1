Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab0CJWHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:07:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:40781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab0CJWHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:07:00 -0500
Message-ID: <4B9817B6.6070400@kernel.org>
Date: Wed, 10 Mar 2010 14:05:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/6] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
References: <1268256267-3769-1-git-send-email-yinghai@kernel.org> <1268256267-3769-6-git-send-email-yinghai@kernel.org> <20100310215018.GD24353@flint.arm.linux.org.uk>
In-Reply-To: <20100310215018.GD24353@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 01:50 PM, Russell King wrote:
> On Wed, Mar 10, 2010 at 01:24:26PM -0800, Yinghai Lu wrote:
>> +/* How much should we pad RAM ending depending on where it is? */
>> +static unsigned long __init ram_alignment(resource_size_t pos)
>> +{
>> +	unsigned long mb = pos >> 20;
>> +
>> +	/* To 64kB in the first megabyte */
>> +	if (!mb)
>> +		return 64*1024;
>> +
>> +	/* To 1MB in the first 16MB */
>> +	if (mb < 16)
>> +		return 1024*1024;
>> +
>> +	/* To 64MB for anything above that */
>> +	return 64*1024*1024;
>> +}
> 
> This doesn't make sense for generic code.
> 
> 1. All architectures do not have RAM starting at physical address 0.
> 2. What about architectures which have relatively little memory (maybe
>    16MB total) split into four chunks of 4MB spaced at 512MB ?

> 
> Other comments:
> 
> 1. It doesn't support mem=size@base, which is used extensively on ARM.

current x86, need to use exactmap...
so could add sth in arch/arm/setup.c to set it.


> 2. How does memory get allocated for creating things like page tables?
find_fw_memmap_area
rerserve_early

> 
> Currently, bootmem supports ARM very well with support for flatmem,
> sparsemem and discontigmem models (the latter being deprecated).  Can
> this code support all three models?
should be ok.
> 
> Where are patches 1 to 4?

my bad, it still have 1/4, 2/4, 3/4, 4/4

> 
> Lastly, why exactly is bootmem being eliminated?  Bootmem offers more
> flexible functionality than this e820 code appears at first read-through
> seems to.
less layer before slab...

fw_memmap.c could be simplified by keeping more stuff in arch/x86/kernel/e820.c
will have one fw_mem_internal.h and only be included by fw_memmap.c and arch fw_memmap.c.

YH



