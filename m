Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbXEQOgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbXEQOgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXEQOgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:36:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:40920 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbXEQOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZdxHw/laJmXEpGWQDudRwzdwqf66l2istS+dek/SDeaug3X/FKQeiDvC5eHhK/itDA881dtOS0hnEM87xaUF5Pl/HsOFLVaWW0343PaaCsDNBsAId/nSrFmGhpTl9bZOAiHBq3c9AvI+8s4JtIsjWnxWSbcpdIjDt6TPhPa8VzM=
Message-ID: <d120d5000705170736q4e9eb5d4jab82732e01e377c@mail.gmail.com>
Date: Thu, 17 May 2007 10:36:36 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] INPUT: Sanitize PIT locking in pcspkr
Cc: LKML <linux-kernel@vger.kernel.org>, "Stable Team" <stable@kernel.org>,
       "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@osdl.org>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Richard Henderson" <rth@twiddle.net>
In-Reply-To: <1179412525.3764.80.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179408962.3764.72.camel@chaos>
	 <d120d5000705170715s2066ea39r9b129e5efe79c4dd@mail.gmail.com>
	 <1179412525.3764.80.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dmitry,
>
> On Thu, 2007-05-17 at 10:15 -0400, Dmitry Torokhov wrote:
> > Hi Thomas,
> >
> > > +#include <asm/i8253.h>
> >
> > I don't see this file in include/asm-i386 and your patch only creates
> > asm-x86_64...
>
> [tglx@inhell4 linux-2.6.21]$ ls include/asm-i386/i82*
> include/asm-i386/i8253.h  include/asm-i386/i8259.h
>

Yes, indeed. I wonder how did I manage not to see it...

> > BTW, is there any reason 8253pit.h can't be used...?
>
> The i386 lock is already exported in i8253.h

Right, since we do have i8253.h on i386 that question does not make sense.

>
> > Hmm... The best way IMO woudl be if arch code attached spinlock that
> > should be used by pcspkr driver to pcspkr platform device (as
> > platform_data) and we would not have private lock at all.
>
> Sounds ugly, but that's not material for now and cannot be applied to
> older kernels, which need this fix as well.
>

But then the driver code does not care about arch details which is nice IMHO.

> BTW, there are more creative PIT users in drivers/input which use the
> global lock already, but the PIT usage there is definitely broken on
> anything >= 2.6.21.
>

Are you talking about drivers/input/joystick/analog.c? What is broken there?

-- 
Dmitry
