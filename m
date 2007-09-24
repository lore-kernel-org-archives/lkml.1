Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbXIXNBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbXIXNBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXIXNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:01:10 -0400
Received: from smtpoutm.mac.com ([17.148.16.78]:60180 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbXIXNBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:01:08 -0400
In-Reply-To: <25045.1190612108@turing-police.cc.vt.edu>
References: <20070922200349.GA2119@martell.zuzino.mipt.ru> <25045.1190612108@turing-police.cc.vt.edu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <902BC866-59A0-4E50-8299-64D38D9E93B1@mac.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Uninline kcalloc()
Date: Mon, 24 Sep 2007 08:59:56 -0400
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 24, 2007, at 01:35:08, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 23 Sep 2007 00:03:49 +0400, Alexey Dobriyan said:
>> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
>> -{
>> -	if (n != 0 && size > ULONG_MAX / n)
>> -		return NULL;
>> -	return __kmalloc(n * size, flags | __GFP_ZERO);
>> -}
>> +void *kcalloc(size_t n, size_t size, gfp_t flags);
>
> NAK.
>
> This busticates some pretty subtle code in mm/slab.c that uses uses  
> __builtin_return_address() for debugging - if you do this, then the  
> "calling function" gets listed as "kcalloc()" rather than the much  
> more useful "function that called kcalloc()" (which is what you  
> care about).
>
> (I remember going around and around multiple times getting those  
> stupid inlines set up right, so that feature actually did something  
> useful, otherwise kcalloc and kzalloc didn't report where they were  
> called from).

Proper fix is to give __kmalloc a "void *caller" parameter and have  
all of the various wrapper functions pass in the value of  
__builtin_return_address() appropriately.  I believe that even works  
properly for inline functions which may or may not be inlined.

Cheers,
Kyle Moffett

