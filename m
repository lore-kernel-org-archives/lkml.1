Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbXKMTLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbXKMTLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXKMTLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:11:34 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:59629 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbXKMTLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:11:33 -0500
Message-ID: <4739F6C7.90408@linux.vnet.ibm.com>
Date: Wed, 14 Nov 2007 00:41:03 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce ext4_find_next_bit
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20071112235910.35a635e4.akpm@linux-foundation.org>
In-Reply-To: <20071112235910.35a635e4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Fri, 21 Sep 2007 10:55:05 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
>> Also add generic_find_next_le_bit
>>
>> This gets used by the ext4 multi block allocator patches.
>>
> 
> arm allmodconfig:
> 
> fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
> fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'
> 
> This patch makes my head spin.
> 
> Why did we declare generic_find_next_le_bit() in
> include/asm-powerpc/bitops.h (wrong) as well as in
> include/asm-generic/bitops/le.h (presumably correct)?
> 

I was following the coding style used for rest of the APIs
like ext4_set_bit.


> Why is it touching a powerpc file and no any other architectures? 
> Something screwed up in powerpc land?
> 
> And why did arm break?

arm and below list of arch doesn't include the asm-generic/bitops/ext2-non-atomic.h 

I did a grep and that list the below architectures as also affected.
arm, m68k, m68knommu, s390

> 
> Shudder.  Anyway, please fix, and if that fix requires that various
> braindamaged be repaired, please repair the braindamage rather than going
> along with it.
> 
> 

That should be a separate patch altogether. I wanted to do the cleanup
along with the usages such as but never got time to do the same.

#define ocfs2_set_bit ext2_set_bit
#define udf_set_bit(nr,addr) ext2_set_bit(nr,addr)
direct usage in mb
md/bitmap.c +799
md/dm-log.c +177

I will send a patch tomorrow that fix  arm and other architectures. I guess the cleanup
can be a separate patch ? 

-aneesh


