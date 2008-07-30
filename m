Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYG3O4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYG3O4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759713AbYG3Oz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:55:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057AbYG3Ozz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:55:55 -0400
Message-ID: <48907F49.7020101@linux-foundation.org>
Date: Wed, 30 Jul 2008 09:48:41 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
 memory
References: <488DF00F.3080809@redhat.com>	 <20080728133504.156f438f.akpm@linux-foundation.org> <84144f020807281342t2e1a3dc3id01314ac01de406f@mail.gmail.com> <488E3414.8020506@redhat.com> <488E3643.8000300@cs.helsinki.fi>
In-Reply-To: <488E3643.8000300@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>> For whatever reason, I did see non-page-aligned memory returned from
>> kmalloc(PAGE_CACHE_SIZE), and I think this is what caused the problem
>> once virt_to_page() was used to get hold of a page to pass around in the
>> ecryptfs/crypto code...
> 
> With SLUB? I can't see how that's possible. I can see this with SLAB,
> though, for 4K pages.

It possible because PAGE_CACHE_SIZE is still handled by SLUB and if debugging is on then   kmalloc may return non page aligned objects. The handoff to the page allocator only occurs for objects > 4k. We used to do this also for 4k objects but then we got performance regressions in tbench.



> In any case, the patch, of course, make sense as kmalloc() behavior
> varies between allocators.
> 
>         Pekka

