Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZCRMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZCRMjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZCRMjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:39:13 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56047 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbZCRMjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:39:13 -0400
Message-ID: <49C0EB46.5050309@vflare.org>
Date: Wed, 18 Mar 2009 18:08:30 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]: compressed RAM block device
References: <49BF8ABC.6040805@vflare.org> <49BF8B4E.1030603@vflare.org> <200903182325.21106.nickpiggin@yahoo.com.au>
In-Reply-To: <200903182325.21106.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090317-0, 17-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 17 March 2009 22:36:46 Nitin Gupta wrote:
>>   drivers/block/Kconfig     |   22 +
>>   drivers/block/Makefile    |    1 +
>>   drivers/block/compcache.c |  995
>> +++++++++++++++++++++++++++++++++++++++++++++ drivers/block/compcache.h | 
>> 160 ++++++++
>>   4 files changed, 1178 insertions(+), 0 deletions(-)
>>
>> Creates RAM based block device (ramzswap0) which can be used as swap
>> device. Pages swapped to this are compressed and stored in memory itself.
>>
>> The module is called compcache.ko. It depends on:
>>   - xvmalloc.ko: memory allocator
>>   - lzo_compress.ko
>>   - lzo_decompress.ko
>>
>> See Documentation/blockdev/compcache.txt for usage details.
>>
>> Project home: http://code.google.com/p/compcache/
> 

> I wonder how hard it would be to make the compression code
> use an arbitrary file or device for the storage backend rather
> than make a new block device? Then you could make a new ram
> block device that can swap its pages out (or even extend brd.c
> with that functionality, or use loop on tmpfs etc).
> 

Its already done as mentioned in Documentation/blockdev/compcache.txt
(patch 3/3) but I should have added it here also: compcache accepts
"backing_dev" parameter for backing swap partition - this allows us to
forward any R/W request to backing swap device. Currently only poorly
compressible pages (compress length > PAGE_SIZE/2) are forwarded to
backing_dev.

Thanks,
Nitin




