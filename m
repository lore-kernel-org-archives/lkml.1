Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZKYSaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZKYSaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbZKYSai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:30:38 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43459 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbZKYSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:30:38 -0500
Message-ID: <4B0D77CC.3020807@cs.helsinki.fi>
Date: Wed, 25 Nov 2009 20:30:36 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
References: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi> <1259173636.29779.41.camel@Joe-Laptop.home>
In-Reply-To: <1259173636.29779.41.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2009-11-25 at 20:21 +0200, Pekka Enberg wrote:
>> The unlikely() annotation in slab_alloc() covers too much of the expression.
>> It's actually very likely that the object is not NULL so use unlikely() only
>> for the __GFP_ZERO expression like SLAB does.
> []
>> +++ b/mm/slub.c
>> @@ -1735,7 +1735,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
>> -	if (unlikely((gfpflags & __GFP_ZERO) && object))
>> +	if (unlikely(gfpflags & __GFP_ZERO) && object)
>>  		memset(object, 0, objsize);
> 
> so why not use
> 
> 	if (unlikely(gfpflags & __GFP_ZERO) && likely(object))

Because that has no effect on the generated code.
