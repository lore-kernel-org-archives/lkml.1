Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXEQOaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXEQOaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEQOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:30:40 -0400
Received: from www.osadl.org ([213.239.205.134]:32946 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754303AbXEQOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:30:39 -0400
Subject: Re: [PATCH] INPUT: Sanitize PIT locking in pcspkr
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Richard Henderson <rth@twiddle.net>
In-Reply-To: <d120d5000705170715s2066ea39r9b129e5efe79c4dd@mail.gmail.com>
References: <1179408962.3764.72.camel@chaos>
	 <d120d5000705170715s2066ea39r9b129e5efe79c4dd@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 16:35:25 +0200
Message-Id: <1179412525.3764.80.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Thu, 2007-05-17 at 10:15 -0400, Dmitry Torokhov wrote:
> Hi Thomas,
> 
> > +#include <asm/i8253.h>
> 
> I don't see this file in include/asm-i386 and your patch only creates
> asm-x86_64...

[tglx@inhell4 linux-2.6.21]$ ls include/asm-i386/i82*
include/asm-i386/i8253.h  include/asm-i386/i8259.h

> BTW, is there any reason 8253pit.h can't be used...?

The i386 lock is already exported in i8253.h

> Hmm... The best way IMO woudl be if arch code attached spinlock that
> should be used by pcspkr driver to pcspkr platform device (as
> platform_data) and we would not have private lock at all.

Sounds ugly, but that's not material for now and cannot be applied to
older kernels, which need this fix as well.

BTW, there are more creative PIT users in drivers/input which use the
global lock already, but the PIT usage there is definitely broken on
anything >= 2.6.21.

> BTW, with all that usevent_supress busiess, does pcspkr gets loaded
> automatically nowadays?

I have no idea.

	tglx


