Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbZA0VyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbZA0VyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZA0Vxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:53:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37022 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZA0Vxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:53:52 -0500
Message-ID: <497F8172.7000403@cs.helsinki.fi>
Date: Tue, 27 Jan 2009 23:49:38 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kmalloc: Return NULL instead of link failure
References: <4975F376.4010506@suse.com> <20090127133723.46eb7035.akpm@linux-foundation.org>
In-Reply-To: <20090127133723.46eb7035.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 20 Jan 2009 10:53:26 -0500
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>>  The SLAB kmalloc with a constant value isn't consistent with the other
>>  implementations because it bails out with __you_cannot_kmalloc_that_much
>>  rather than returning NULL and properly allowing the caller to fall back
>>  to vmalloc or take other action. This doesn't happen with a non-constant
>>  value or with SLOB or SLUB.
>>
>>  Starting with 2.6.28, I've been seeing build failures on s390x. This is
>>  due to init_section_page_cgroup trying to allocate 2.5MB when the max
>>  size for a kmalloc on s390x is 2MB.
>>
>>  It's failing because the value is constant. The workarounds at the call
>>  size are ugly and the caller shouldn't have to change behavior depending
>>  on what the backend of the API is.
>>
>>  So, this patch eliminates the link failure and returns NULL like the
>>  other implementations.
>>
> 
> OK by me, is that's what the other sl[abcd...xyz]b.c implementations
> do.
> 
> That __you_cannot_kmalloc_that_much() thing has frequently been a PITA
> anyway - some gcc versions flub the constant_p() test and end up
> referencing __you_cannot_kmalloc_that_much() when the callsite was
> passing a variable `size' arg.

[snip]

> Strange patch format, but it applied.
> 
> I'll punt this patch in the Pekka direction.

Applied, thanks!

		Pekka
