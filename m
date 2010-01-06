Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137Ab0AFTYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0AFTYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982Ab0AFTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:24:09 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:43241 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0AFTYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:24:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=N94VmaMI2Dm6PURv5ZOOa1ixFn9HlKG3U1gMJIzQmmo3YJuGREZATU9LdkK4KSEUeu
         DZ3ZJhGLFMl4zKr+d5dv/ASuqlrbJxfIhL4Xi7MtZPZZHBDptLJMcD5c1Hs7BWM2L408
         PUYkMiMQEkaWiyZaRWtWHrshYYUc5gdYzjsec=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001051620030.9108@router.home>
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com> 
	<8bd0f97a1001051417w288440b4h65b6b01d4ad36a72@mail.gmail.com> 
	<alpine.DEB.2.00.1001051620030.9108@router.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 6 Jan 2010 14:23:47 -0500
Message-ID: <8bd0f97a1001061123w15278d0cr4e74c88f22fa6e6e@mail.gmail.com>
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and 
	add_local_return()
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 17:29, Christoph Lameter wrote:
> On Tue, 5 Jan 2010, Mike Frysinger wrote:
>> On Tue, Jan 5, 2010 at 17:04, Christoph Lameter wrote:
>> > --- /dev/null   1970-01-01 00:00:00.000000000 +0000
>> > +++ linux-2.6/include/asm-generic/add-local.h   2010-01-05 15:36:02.000000000 -0600
>> > @@ -0,0 +1,13 @@
>> > +#ifndef __ASM_GENERIC_ADD_LOCAL_H
>> > +#define __ASM_GENERIC_ADD_LOCAL_H
>>
>> needs comment header (blurb/copyright/license)
>
> A simple small include file? Really?

if there's enough content to warrant protection against multiple
inclusion, then generally yes

>> > --- /dev/null   1970-01-01 00:00:00.000000000 +0000
>> > +++ linux-2.6/arch/alpha/include/asm/add-local.h        2010-01-05 15:36:02.000000000 -0600
>> > @@ -0,0 +1,2 @@
>> > +#include <asm-generic/add-local.h>
>> > +
>>
>> these arch stubs all have an extra new line
>
> Thats bad?

files shouldnt have trailing new lines

>> > +/*
>> > + * Generic version of __add_return_local (disables interrupts). Takes an
>> > + * unsigned long parameter, supporting various types of architectures.
>> > + */
>> > +static inline unsigned long __add_return_local_generic(volatile void *ptr,
>> > +               unsigned long value, int size)
>>
>> size_t for size ?
>
> No. It can be anything.

you're passing it sizeof() which returns a size_t

>> > +extern unsigned long wrong_size_add_local(volatile void *ptr);
>> > ...
>> > +       /*
>> > +        * Sanity checking, compile-time.
>> > +        */
>> > +       if (size == 8 && sizeof(unsigned long) != 8)
>> > +               wrong_size_add_local(ptr);
>> > ...
>> > +       default:
>> > +               wrong_size_add_local(ptr);
>> > +       }
>>
>> should be BUILD_BUG_ON() ?
>
> Does not work there.

why not ?  BUILD_BUG_ON() should work on any compile-time constant
which sizeof() is ... unless you plan on letting people call this
function with arbitrary sizes ?
-mike
