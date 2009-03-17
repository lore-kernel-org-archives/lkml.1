Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZCQR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZCQR4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZCQR4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:56:04 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:62881 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbZCQR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TO0AEWf1r8+GtxuGEZSXEPQ/7pOdS1QzX2z+5yodrPr8V4O0b1p+aXv7pQVIKoKssk
         l33/nwi2pFISNrxPge5RjWqXi0GACyXo/lBbXVB/y+TYD/d52AfWFpDnxm/kT7nXL9wi
         oPkpox5VadOPgF9cWNVj0U2qxe0dXcNKfkbiY=
Message-ID: <49BFE415.8020803@vflare.org>
Date: Tue, 17 Mar 2009 23:25:33 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org> <alpine.DEB.1.10.0903171237180.21582@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903171237180.21582@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sending again since it was blocked by lkml last time. Sorry Christoph for duplicate email).

Christoph Lameter wrote:
> On Tue, 17 Mar 2009, Nitin Gupta wrote:
> 
>> Slub allocator could not be used due to fragmentation issues:
>> http://code.google.com/p/compcache/wiki/AllocatorsComparison
>> Data here shows kmalloc using ~43% more memory than TLSF and xvMalloc
>> is showed ~2% more space efficiency than TLSF (due to smaller metadata).
> 
> Well this looks like the use of 2^n sizes of the kmalloc arrayse cause a
> lot of wastage here. Creating slab caches that fit your needs may help?

Creating slabs for sizes in range, say, [32, 3/4*PAGE_SIZE] separated by 64bytes
will require 48 slabs! Then for slab of each size class will have wastage due to
unused slab objects in each class.
Larger difference in slab sizes (and thus small no. of them), will surely cause too much
wastage due to internal fragmentation.

Another (more important) point to consider is that, use of slabs will eat-up vmalloc
area to keep slab memory backed by VA space. On 32-bit systems, vmalloc area
is small and limits amount of memory that can be allocated for compressed pages.
With xvmalloc we map/unmap pages on demand thus removing dependence on
vmalloc VA area.

 > Have you had a look at the SLOB approach?
 >

Nope. I will see how this may help.

Thanks,
Nitin

