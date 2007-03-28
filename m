Return-Path: <linux-kernel-owner+w=401wt.eu-S965816AbXC1XwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965816AbXC1XwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965817AbXC1XwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:52:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:38876 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965816AbXC1XwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=DTYeg9IivdI7y4+s7llK/MjCCqAyGj0Q0C5gNAOYU1yEP01NI5DAAsAWrbN/7jRbM0WCO9OhfUyXqKS/W/MhRwfRUhah5JRl7BrcwU9HPtASeKhyySshBBmu6ZfDyfpQbxHuuGDQadhTOuW0mj2doS+NyIiGXB3feEMej41lAH8=
Date: Thu, 29 Mar 2007 02:52:15 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1547009361.20070329025215@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [RFC] Virtual methods for devices and generalized GPIO support using it
In-Reply-To: <460A98B9.9040602@zytor.com>
References: <881020209.20070327113610@gmail.com> <460A98B9.9040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello H.,

Wednesday, March 28, 2007, 7:32:57 PM, you wrote:

> Paul Sokolovsky wrote:
>> 
>> In this respect, VTABLE(), METHOD() macros serve the same purpose as 
>> container_of() and list_for_each() - they are besides offering (more) 
>> convenient syntax, also carry important annotattion and educational
>> messages, like "it's ok, and encouraged to embed one structure into 
>> another - use it!" or "list manipulation is a trivial operation for kernel,
>> and we want you to treat it as such and use in standard, easily 
>> distinguishable way".
>> 

> You realize, right, that the Linux kernel already have a much cleaner 
> way to do vtables in the kernel, without this kind of macro crappage? 
> It's called an _ops table, and is used in a patternized way:

foo->x_ops->func(foo, ...);

> ... all over the kernel.  We like it that way.

  Sure! I wrote it's nothing really new. And I hope it's clear why
those macros appeared in the first place: with the type of structures
the device virtual methods are intended to be used, there're always
pretty comprehensive member selection and typecasting is required. In
this regard, there were 3 choices:

1. Use long but explicit expressions, like

((struct dev_pdata*)pdev.dev->platform_device)->x_ops->func(dev)

2. Use temporary variables:

struct dev_pdata *tmp = (struct dev_pdata*)pdev.dev->platform_device;
tmp->x_ops->func(dev);

3. Introduce macros which would hide guts and would provide syntax
more resembling usual function call (especially for folks who remember
that preprocessor is unalienable part of C ;-) ).


     As I also noted in the original mail, macros are also nice device
for in-place annotation - to emphasize the fact that this is not just
a mundane case of pointer manipulation, but paradigmatic thing.


     By this criteria I happened to choose macros syntax. But it's still
merely a syntax, and I don't pledge for it. If there's more movement
towards using explicit low-level forms like 1) or 2) instead of
introducing new syntactic pattern, then macro syntax can be considered
to have fulfilled its introductory role and can be dropped.




>         -hpa



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

