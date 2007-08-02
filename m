Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXHBMYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXHBMYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbXHBMYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:24:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36064 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXHBMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:24:45 -0400
Date: Thu, 2 Aug 2007 14:24:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] type safe allocator
In-Reply-To: <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708021417400.24572@fbirervta.pbzchgretzou.qr>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> 
 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu> <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 16:04, Alexey Dobriyan wrote:
>On 8/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>   fooptr = kmalloc(sizeof(struct foo), ...);
>
>Key word is "traditional". Good traditional form which even half-competent
>C programmers immediately parse in retina.

And being aware of the potential type-unsafety makes programmers more
careful IMHO.

>
>> +/**
>> + * alloc_struct - allocate given type object
>> + * @type: the type of the object to allocate
>> + * @flags: the type of memory to allocate.
>> + */
>> +#define alloc_struct(type, flags) ((type *) kmalloc(sizeof(type), flags))

>someone will write alloc_struct(int, GFP_KERNEL), I promise.

and someone else will write

	struct complexthing foo;
	alloc_struct(foo, GFP_KERNEL);



	Jan
-- 
