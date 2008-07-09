Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYGIFQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYGIFQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 01:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYGIFQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 01:16:11 -0400
Received: from smtp3.infineon.com ([203.126.106.229]:39582 "EHLO
	smtp3.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYGIFQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 01:16:10 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jul 2008 01:16:10 EDT
X-SBRS: None
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Kmem_cache handling in linux-2.6.2x kernel
Date: Wed, 9 Jul 2008 13:06:01 +0800
Message-ID: <31E09F73562D7A4D82119D7F6C172986046C6ACA@sinse303.ap.infineon.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kmem_cache handling in linux-2.6.2x kernel
Thread-Index: AcjhgXsrE7+KAd16Sfe0vuem36aMAw==
From: <KokHow.Teh@infineon.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jul 2008 05:06:01.0930 (UTC) FILETIME=[7B836AA0:01C8E181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list;
	I have a question about kmem_cache implemented in Linux-2.6.2x
kernel. I have an application that allocates and free 64KByte chunks of
memory (32-byte aligned) quite often. Therefore, I create a lookaside
cache for that purpose and use kmem_cache_alloc(), kmem_cache_free() to
allocate and free the caches. The application works very well in this
model. However, my concern here is if kmem_cache_free() does return the
cache to the system-wide pool so that it could be used by other
applications when need arises; when system is low in memory resources,
for instance. This is a question about the internal workings of the
memory management system of the Linux-2.6.2x kernel as to how efficient
it manages this lookasie caches. The concern is valid because if this
lookaside cache is not managed well, i.e, it is not returned to the
system-wide free memory pools to be used by other applications, this
will penalize the performace and throughput of the whole system due to
the dynamic behaviour of the utilization of system memory resources. For
example, other applications might be swapping in and out of the harddisk
and if the kmem_cache_free()'ed memory objects could be used by these
applications, it will help in this case to reduce the number of swaps
that happen, thereby freeing the CPU and/or DMA from doing the swapping
to do other critical tasks.

	On the other hand, if the caches are returned to the system-wide
free memory pool, what are the advantages of using kmem_cache_t compared
to the conventional kmalloc()/kfree()?

	Any insight and advice is appreciated.

Regards,
KH
