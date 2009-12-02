Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZLBHBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZLBHBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 02:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZLBHBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 02:01:09 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41195 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZLBHBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 02:01:09 -0500
Message-ID: <4B1610BA.5090906@cs.helsinki.fi>
Date: Wed, 02 Dec 2009 09:01:14 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: Q, slab, kmemleak_erase() and redzone?
References: <4B1502E3.4000304@cs.helsinki.fi> <1259690210.2121.233.camel@pc1117.cambridge.arm.com> <4B1609D0.6030809@cs.helsinki.fi> <4B160A16.90703@cs.helsinki.fi> <9890.1259737038@jrobl>
In-Reply-To: <9890.1259737038@jrobl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

hooanon05@yahoo.co.jp kirjoitti:
> Pekka Enberg:
>>> No, you are absolutely correct. Can you please send an updated patch to 
>>> Catalin that adds a comment on top of the cpu_cache_get() call that 
>>> explains why we need it there?
>> Doh, this was supposed to be a reply to Okajima's email :-).
> 
> Before I send a small patch, let me make sure about other small issues.
> 
> - How heavy is 'ac = cpu_cache_get(cachep)' (which will be inserted by
>   the patch)?
>   It will be compiled and executed regardless CONFIG_DEBUG_KMEMLEAK, and
>   it is totally meaningless when DEBUG_KMEMLEAK is disabled. Can we
>   ignore this loss?

No, it won't be. The compiler should notice it's dead code and remove it 
when CONFIG_KMEMLEAK is disabled.

> - Should we add a condition 'if (objp)' before calling kmemleak_erase()?
>   As Catalin wrote, it may be harmless. But setting NULL is unnecessary.
>   Do you accept this change too?

Yeah, I'd prefer to see the check there. While Catalin is correct, 
that's not obvious from reading the code.

			Pekka
