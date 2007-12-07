Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXLGFIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXLGFIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXLGFIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:08:39 -0500
Received: from [222.73.24.84] ([222.73.24.84]:63835 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXLGFIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:08:39 -0500
Message-ID: <4758D49A.8090908@cn.fujitsu.com>
Date: Fri, 07 Dec 2007 13:05:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: paulus@samba.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] POWERPC: don't cast a pointer to pointer of list_head
References: <4757C1DA.6060603@cn.fujitsu.com> <200712071507.10161.nickpiggin@yahoo.com.au>
In-Reply-To: <200712071507.10161.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin 写道:
> On Thursday 06 December 2007 20:33, Li Zefan wrote:
>> The casting is safe only when the list_head member is the
>> first member of the structure.
> 
> Even so, I don't think too safe :) It might technically work,
> but it could break more easily.
> 
> So even if you find places where list_head is the first member of
> a structure, it would be nice to explicitly use the list_head member
> and avoid casts IMO.
> 

This is exactly what I think. Those patches actually fix no bugs, but
avoid this kind of technically and currently correct casting.

> 
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>
>> ---
>>  arch/ppc/syslib/ocp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/ppc/syslib/ocp.c b/arch/ppc/syslib/ocp.c
>> index 3f5be2c..d42d408 100644
>> --- a/arch/ppc/syslib/ocp.c
>> +++ b/arch/ppc/syslib/ocp.c
>> @@ -376,7 +376,7 @@ ocp_remove_one_device(unsigned int vendor, unsigned int
>> function, int index)
>>
>>  	down_write(&ocp_devices_sem);
>>  	dev = __ocp_find_device(vendor, function, index);
>> -	list_del((struct list_head *)dev);
>> +	list_del(&dev->link);
>>  	up_write(&ocp_devices_sem);
>>
>>  	DBG(("ocp: ocp_remove_one_device(vendor: %x, function: %x, index: %d)...
>> done.\n", vendor, function, index));
> 
> 


