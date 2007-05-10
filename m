Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbXEJIq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbXEJIq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXEJIqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:46:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:41941 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304AbXEJIqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:46:18 -0400
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <a781481a0705100054r45c373a0lfd35b8b31b0e6032@mail.gmail.com>
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	 <20070509224113.cca81a24.akpm@linux-foundation.org>
	 <a781481a0705092345rf9fdc9cs8495516299a28fae@mail.gmail.com>
	 <1178781677.14928.221.camel@localhost.localdomain>
	 <a781481a0705100054r45c373a0lfd35b8b31b0e6032@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 18:46:01 +1000
Message-Id: <1178786761.14928.232.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 13:24 +0530, Satyam Sharma wrote:
> But then, what _is_ the problem with your approach above? An arch that
> wants (and implements) hard_irq_disable will also #define that dummy
> macro, so we just need to pull in the appropriate header (directly,
> indirectly, anyhow -- we don't really care) into
> include/linux/interrupt.h and then just do the exact same "#ifndef
> hard_irq_disable" check that you're doing right now. I must be missing
> something trivial (either that or I need to go and have a coffee :-)
> because I don't see the possibility of hitting multiple _different_
> definitions with the approach you mentioned just now.

Sure, the only problem is that I don't want to pull asm/hw_irq.h
directly from linux/interrupts.h unless all arch maintainers around
verify it's ok, because those headers are a bit of a can of worm at the
moment ...

So I'd rather say that if your arch has a custom version of
hard_irq_disable(), make sure that asm/system.h pulls it in a way or
another. And that's already included.

Ben.


