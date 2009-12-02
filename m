Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZLBGct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZLBGct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZLBGcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:32:48 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60397 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZLBGcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:32:48 -0500
Message-ID: <4B160A16.90703@cs.helsinki.fi>
Date: Wed, 02 Dec 2009 08:32:54 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org
Subject: Re: Q, slab, kmemleak_erase() and redzone?
References: <4B1502E3.4000304@cs.helsinki.fi> <1259690210.2121.233.camel@pc1117.cambridge.arm.com> <4B1609D0.6030809@cs.helsinki.fi>
In-Reply-To: <4B1609D0.6030809@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg kirjoitti:
> Catalin Marinas kirjoitti:
>> On Tue, 2009-12-01 at 11:49 +0000, Pekka Enberg wrote:
>>> hooanon05@yahoo.co.jp kirjoitti:
>>>> Pekka Enberg:
>>>>> We are setting an element in the per CPU array to NULL so the the
>>>>> kmemleak code in ____cache_alloc() is safe. Red-zoning is done at the
>>>>> _object_ which is not touched by kmemleak. Looking at the oops, it
>>>>> does seem likely that you have a bug in your module (or in some other
>>>>> part of the kernel).
>>>> Thanks for reply.
>>>> In ____cache_alloc(), the variable 'ac' is assigned before
>>>> cache_alloc_refill() call, and it is used for the parameter of
>>>> kmemleak_erase(). The value may be changed by cache_alloc_refill(),
>>>> isn't it?
>>> No. The pointer returned by cpu_cache_get() is not changed by
>>> cache_alloc_refill(). The contents of the array might change, yes. That
>>> said, we should check if objp is NULL before calling kmemleak_erase().
>>
>> Possibly but I don't understand why that's needed. The kmemleak_erase()
>> call just sets the ac->entry[ac->avail] to NULL. If ac->avail is 0, it
>> doesn't cause any harm.
> 
> No, you are absolutely correct. Can you please send an updated patch to 
> Catalin that adds a comment on top of the cpu_cache_get() call that 
> explains why we need it there?

Doh, this was supposed to be a reply to Okajima's email :-).

			Pekka
