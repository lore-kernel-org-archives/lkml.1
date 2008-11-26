Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYKZQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYKZQjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYKZQjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:39:43 -0500
Received: from www.tglx.de ([62.245.132.106]:54228 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYKZQjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:39:42 -0500
Date: Wed, 26 Nov 2008 17:38:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <7c86c4470811260556l3b161f1fx639d7ee02285a93@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811261727200.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>  <20081126113309.GS6703@one.firstfloor.org>  <20081126230529.ab37fb32.sfr@canb.auug.org.au>  <alpine.LFD.2.00.0811261430120.3325@localhost.localdomain>
 <7c86c4470811260556l3b161f1fx639d7ee02285a93@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Wed, 26 Nov 2008, stephane eranian wrote:
> > I have not yet found a good reason why it needs to use u64 instead of
> > using what's there already.
> >
> There is a good reason why we cannot use unsigned long. We must make sure
> all data structures exchanged between user mode and the kernel have fixed size.
> This way, we can have a 32-bit tool run unmodified on top of a 64-bit kernel AND
> we do not need trampoline code to marshall/unmarshall the parameters.

That's not a good reason at all. We have in kernel interfaces and
kernel-userspace interfaces. Making them the same is nice if it works,
but horrible if it imposes crappy hackery like the bitops wrappers.

> And yes, the abstraction for bitmask ops was introduced because of issues
> casting u64 -> unsigned long on Big-Endian32-bit machines such as PPC32.

Sorry, I think it is simply stupid.

You can keep the userspace interface u64 and use unsigned long for the
bitmasks in the kernel and take care of it in the user space interface
code and do the BE32 conversion when you copy stuff from and to user.

That's a single well defined place and does not add extra crappola
over the kernel especially not into hot pathes like the interrupt. 

Why do you want to do u64 -> u32 BE32 magic on every interrupt,
context switch etc., if you can do it once in the userspace interface ?

Thanks,

	tglx


