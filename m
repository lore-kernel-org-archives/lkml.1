Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYGIKai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYGIKai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYGIKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:30:30 -0400
Received: from smtp3.infineon.com ([203.126.106.229]:30720 "EHLO
	smtp3.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYGIKa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:30:29 -0400
X-SBRS: None
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Kmem_cache handling in linux-2.6.2x kernel
Date: Wed, 9 Jul 2008 18:30:26 +0800
Message-ID: <31E09F73562D7A4D82119D7F6C172986046C7113@sinse303.ap.infineon.com>
In-Reply-To: <84144f020807090306o49f4deb4m3ded12acc961f214@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kmem_cache handling in linux-2.6.2x kernel
Thread-Index: Acjhq4kdOSbkPr+fTCSu/yyDEW13GQAAJ48g
References: <31E09F73562D7A4D82119D7F6C172986046C6ACA@sinse303.ap.infineon.com> <84144f020807090306o49f4deb4m3ded12acc961f214@mail.gmail.com>
From: <KokHow.Teh@infineon.com>
To: <penberg@cs.helsinki.fi>
Cc: <linux-kernel@vger.kernel.org>, <cl@linux-foundation.org>
X-OriginalArrivalTime: 09 Jul 2008 10:30:27.0712 (UTC) FILETIME=[CE060800:01C8E1AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

>On Wed, Jul 9, 2008 at 8:06 AM,  <KokHow.Teh@infineon.com> wrote:
>>        I have a question about kmem_cache implemented in Linux-2.6.2x

>> kernel. I have an application that allocates and free 64KByte chunks 
>> of memory (32-byte aligned) quite often. Therefore, I create a 
>> lookaside cache for that purpose and use kmem_cache_alloc(), 
>> kmem_cache_free() to allocate and free the caches. The application 
>> works very well in this model. However, my concern here is if 
>> kmem_cache_free() does return the cache to the system-wide pool so 
>> that it could be used by other applications when need arises; when 
>> system is low in memory resources, for instance. This is a question 
>> about the internal workings of the memory management system of the 
>> Linux-2.6.2x kernel as to how efficient it manages this lookasie 
>> caches. The concern is valid because if this lookaside cache is not 
>> managed well, i.e, it is not returned to the system-wide free memory 
>> pools to be used by other applications, this will penalize the 
>> performace and throughput of the whole system due to the dynamic 
>> behaviour of the utilization of system memory resources. For example,

>> other applications might be swapping in and out of the harddisk and
if 
>> the kmem_cache_free()'ed memory objects could be used by these 
>> applications, it will help in this case to reduce the number of swaps

>> that happen, thereby freeing the CPU and/or DMA from doing the
swapping to do other critical tasks.

>I'm not sure I understand the question. The pages allocated for a
particular cache are given back to the page allocator whenever all
objects of a slab are freed. 

In my applications, only part of total number of objects of the
kmem_cache are freed. So my question is what happen to these "freed"
objects? How are these "freed" objects managed by the linux-MM? Would
they be reused by other kmem_cache_alloc() and/or kmalloc()?

>In addition, SLUB does slab merging so the same cache can be
transparently used by other kmem_cache_alloc() callers. So there really
are no reservation guarantees for a cache in OOM conditions.

(1) SLUB is not available in 2.6.20 kernel which I am using for my
products. In this case, is there similar mechamisms in place to
faciliate "page-sharing" amongst the kmem_cache_alloc() callers?

(2) Does this "page-sharing" happen for kmalloc() callers?

On Wed, Jul 9, 2008 at 8:06 AM,  <KokHow.Teh@infineon.com> wrote:
>>        On the other hand, if the caches are returned to the 
>> system-wide free memory pool, what are the advantages of using 
>> kmem_cache_t compared to the conventional kmalloc()/kfree()?

>The main advantages for using kmem_cache_create() are that (1) you
control the alignment and (2) you get tighter packing for the objects
(less internal fragmentation).

Thanks.

Regards,
KH
