Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbXEJHy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbXEJHy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbXEJHyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:54:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:25016 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640AbXEJHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qcE80psx/GYDu89vbhbIofp0JWp8rZNLRJCgOWXFPiARaz330I8H9Mz7sDxn1HiGh+0BCKP8X02kSA+Xrfy3jpLy1RJy6OLvH752qyWcQx9zcaqeDEekc032tVzaAA1ADGPL4kLXN5OiOlU+kI9qz27E7sXkJOE+5xSUBTqcQXQ=
Message-ID: <a781481a0705100054r45c373a0lfd35b8b31b0e6032@mail.gmail.com>
Date: Thu, 10 May 2007 13:24:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <1178781677.14928.221.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	 <20070509224113.cca81a24.akpm@linux-foundation.org>
	 <a781481a0705092345rf9fdc9cs8495516299a28fae@mail.gmail.com>
	 <1178781677.14928.221.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
> > So you're saying that this mechanism forces the arch (that really
> > wants hard_irq_disable) to _#define_ hard_irq_disable (as a macro),
> > and if it implements it as an inline function, for example, then we're
> > screwed?
>
> No. The idea is to do like we did for a few other things already
> (according to Linus request in fact), which is to write
>
> static inline void hard_irq_disable(void)
> {
>         .../...
> }
> #define hard_irq_disable hard_irq_disable
>
> This is nicer than having an ARCH_HAS_xxx

Ok, that's reasonable, we don't want to end up with zillions of
ARCH_HAS_THIS and ARCH_HAS_THAT.

But then, what _is_ the problem with your approach above? An arch that
wants (and implements) hard_irq_disable will also #define that dummy
macro, so we just need to pull in the appropriate header (directly,
indirectly, anyhow -- we don't really care) into
include/linux/interrupt.h and then just do the exact same "#ifndef
hard_irq_disable" check that you're doing right now. I must be missing
something trivial (either that or I need to go and have a coffee :-)
because I don't see the possibility of hitting multiple _different_
definitions with the approach you mentioned just now.
