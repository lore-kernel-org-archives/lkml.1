Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYGILXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYGILXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYGILXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:23:46 -0400
Received: from smtp3.infineon.com ([203.126.106.229]:17187 "EHLO
	smtp3.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYGILXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:23:46 -0400
X-SBRS: None
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Kmem_cache handling in linux-2.6.2x kernel
Date: Wed, 9 Jul 2008 19:23:42 +0800
Message-ID: <31E09F73562D7A4D82119D7F6C172986046C717D@sinse303.ap.infineon.com>
In-Reply-To: <84144f020807090342h36719b2exa8bea85625a127e9@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kmem_cache handling in linux-2.6.2x kernel
Thread-Index: AcjhsHYmXJvUHh34QImK0glILTWlEgAAxONg
References: <31E09F73562D7A4D82119D7F6C172986046C6ACA@sinse303.ap.infineon.com> <84144f020807090306o49f4deb4m3ded12acc961f214@mail.gmail.com> <31E09F73562D7A4D82119D7F6C172986046C7113@sinse303.ap.infineon.com> <84144f020807090342h36719b2exa8bea85625a127e9@mail.gmail.com>
From: <KokHow.Teh@infineon.com>
To: <penberg@cs.helsinki.fi>
Cc: <linux-kernel@vger.kernel.org>, <cl@linux-foundation.org>
X-OriginalArrivalTime: 09 Jul 2008 11:23:42.0731 (UTC) FILETIME=[3E673DB0:01C8E1B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi; 

>On Wed, Jul 9, 2008 at 1:30 PM,  <KokHow.Teh@infineon.com> wrote:
>> In my applications, only part of total number of objects of the 
>> kmem_cache are freed. So my question is what happen to these "freed"
>> objects? How are these "freed" objects managed by the linux-MM? Would

>> they be reused by other kmem_cache_alloc() and/or kmalloc()?

>The free'd objects will be returned to the cache and are, of course,
reused by later kmem_cache_alloc() and kmalloc() calls. 
>Note that with _SLAB_, you never have cache sharing, so an object
free'd by kmem_cache_free() is only available for a kmem_cache_alloc()
of the same cache.

So with _SLAB_, kmem_cache_free() objects are only reusuable by
kmem_cache_alloc() of the same cache.

Are kmem_cache_free() objects reusable by _all_ kmalloc() calls? (*)

>At some point in time, I wrote:
>>>In addition, SLUB does slab merging so the same cache can be  
>>>transparently used by other kmem_cache_alloc() callers. So there 
>>>really  are no reservation guarantees for a cache in OOM conditions.

>On Wed, Jul 9, 2008 at 1:30 PM,  <KokHow.Teh@infineon.com> wrote:
>> (1) SLUB is not available in 2.6.20 kernel which I am using for my 
>> products. In this case, is there similar mechamisms in place to 
>> faciliate "page-sharing" amongst the kmem_cache_alloc() callers?

>No.

>On Wed, Jul 9, 2008 at 1:30 PM,  <KokHow.Teh@infineon.com> wrote:
>> (2) Does this "page-sharing" happen for kmalloc() callers?

>The caches for kmalloc() are set up first, so a kmalloc() never dips
into a cache created by kmem_cache_create(). 

This conflicts with (*) above.

>But a kmem_cache_alloc() can dip into a kmalloc cache. Look at the
create_kmalloc_cache() calls in kmem_cache_init() and the
find_mergeable() call in
>kmem_cache_create() in mm/slub.c for details.

>Btw, you mentioned that you're allocating 64 KBs. So with SLUB, if you
use _kmalloc()_ the request will be passed through to the page allocator
directly (see kmalloc_large()).

What's your point here? How would this compare to using the kmem_cache?

Thanks.

Regards,
KH
