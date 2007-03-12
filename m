Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXCLLUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXCLLUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965681AbXCLLUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:20:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54475 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965647AbXCLLUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:20:47 -0400
Date: Mon, 12 Mar 2007 12:20:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
       oleg@tv-sign.ru, sebastien.dugue@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312112045.GC11864@one.firstfloor.org>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org> <20070312110417.GA12308@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312110417.GA12308@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> if HIGH_RES_TIMERS is disabled then that is what happens. But frankly, 

disabled? I would expect it (= more wakeups) when hrtimers are enabled.

> most futex waits are without timeouts - if an application cares about 
> micro-effects like that then you are much better off not using a 
> per-futex timeout anywa

That sounds like you're arguing for not using hrtimers here because
the applications shouldn't depend on precise timeouts here anyways?!? 

Anyways when you convert more kernel timeouts to hrtimers you should
probably add some kind of batching facility that can be globally
configured with a sysctl or similar. Then at least laptops (and possibly
servers) can opt for more power saving again. For the futexes alone
it probably won't matter too much agreed, but I see a trend to more hr.

I also liked the idea (stolen from another popular OS) that a application
can tell the OS how precise it wants its wakeups to be.

-Andi

