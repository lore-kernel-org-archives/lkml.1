Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbZEMUVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbZEMUVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZEMUVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:21:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZEMUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:21:20 -0400
Message-ID: <4A0B2B54.5090803@zytor.com>
Date: Wed, 13 May 2009 13:19:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>
In-Reply-To: <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> 
> I think it's good time to decide making all architectures
> which have readq/writeq provide HAVE_READQ/HAVE_WRITEQ or not.
> 
> Adding HAVE_READQ/HAVE_WRITEQ to Kconfig of architectures needs
> agreement of all maintainers of these.
> 
> But, David Miller, maintainer of SPARC architecture, acked Roland's patch
> because of the possibility of bugs non-atomicity of readq/writeq of
> x86-32 will cause.
> 
> And, Jeff Garzik said that he saw zero justification for API removal.
> 
> Which way should we choose?
> Remove readq/writeq from x86-32?
> Or add HAVE... to all architectures with readq/writeq?

There is another option, which is to have canned include variants, that
drivers can explicitly opt-in with:

#include <linux/io64_lh.h>

linux/io64_lh.h would then look like:

#ifndef _LINUX_IO64_LH_H
#define _LINUX_IO64_LH_H

#include <linux/io.h>

#ifndef HAVE_READQ

/* Low-High nonatomic readq() */

#endif

#ifndef HAVE_WRITEQ

/* Low-High nonatomic writeq() */

#endif

#endif


If we need more than io64_lh.h we can then add other variants, but I
suspect we won't need them -- except possibly an io64_hl.h.

	-hpa
