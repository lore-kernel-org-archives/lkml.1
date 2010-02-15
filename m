Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0BOEv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:51:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:46389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab0BOEv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:51:57 -0500
Message-ID: <4B78D299.8070309@kernel.org>
Date: Sun, 14 Feb 2010 20:50:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH -v7 0/35] tip related: not use  bootmem for x86
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1266200846.16346.111.camel@pasglop>
In-Reply-To: <1266200846.16346.111.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 06:27 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2010-02-10 at 01:20 -0800, Yinghai Lu wrote:
>>
>> The reserve_early() method is list/range based and can handle vast
>> amounts of not very fragmented memory - perfect for basically all the
>> real bootmem purposes (which is to bootstrap the buddy).
>>
>> reserve_early() allocated memory could be freed into the buddy later
>> on
>> as well. The main reason why bootmem is 'destroyed' during
>> free-to-buddy
>> is because it has excessive internal bitmaps we want to free. With a
>> list/range based reserve_early() mechanism there's no such problem -
>> they can linger indefinitely and there's near zero allocation
>> management
>> overhead. " 
> 
> Various archs use lib/lmb.c for representing physical memory and
> doing early allocations. Might be something to extend ?

yes, could merge them later.

lmb: include memory range array, and reserved range array, and will be used till bootmem_init

early_res: is only reserved range array..., and need to be use with e820 map...
and now early_res is used to replace bootmem...

will check to make e820 to be fw_memmap and move it /kernel/fw_memmap.c

Thanks

Yinghai
