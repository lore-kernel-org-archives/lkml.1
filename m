Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0CJWck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:32:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:46864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367Ab0CJWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:32:39 -0500
Message-ID: <4B981DBD.2060303@kernel.org>
Date: Wed, 10 Mar 2010 14:31:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
References: <4B981049.3040607@kernel.org>	<20100310.133646.144946890.davem@davemloft.net>	<4B9818CE.7090809@kernel.org> <20100310.141757.95833226.davem@davemloft.net>
In-Reply-To: <20100310.141757.95833226.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 02:17 PM, David Miller wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Wed, 10 Mar 2010 14:10:22 -0800
> 
>> On 03/10/2010 01:36 PM, David Miller wrote:
>>> And LMB cannot fill this void with some minor modifications?
>>
>> early_res array could be increased automatically...
>>
>> could be something like:
>> keep lmb.memory part, and use early_res for reserved parts...
> 
> LMB has a reserved region.
> 
> I still have yet to see any fundamental reason why LMB
> cannot, all by itself, be used to solve this problem too.

they are array based.

1. memmap is not changed after get it from firmware, <could be modified via mem= or memmap=>
2. early_res at first is static array, later it will be relocated to another position if the array is not big enough.

so arch only need to have it's own setup_memory_map, to fill fw_memmap according to FW,
and later using find_fw_memmap_area and reserve_early all the way...
<don't need allocate bootmem map anymore>

later in mem_init to call free_all_memory_core_early instead.
<it will use memory subtract all reserved list to get final free list, and ...>

YH

