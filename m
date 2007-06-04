Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXFDSMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXFDSMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbXFDSMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:12:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:38159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbXFDSMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:12:43 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lguest rebroken in 2.6.22-rc3-mm1
Date: Mon, 4 Jun 2007 20:12:15 +0200
User-Agent: KMail/1.9.1
Cc: Matt Mackall <mpm@selenic.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
References: <20070522223828.GV11115@waste.org> <20070604171932.GE11115@waste.org> <20070604102820.a4a0ee15.akpm@linux-foundation.org>
In-Reply-To: <20070604102820.a4a0ee15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706042012.15915.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > Looks like this one got lost in rc3-mm1.
>
> Andi said that he fixed the zero-divide by other means?

I determined it cannot happen in my source tree. When notsc
is passed TSC CPUID is cleared and sched-clock works.

I suspect what happens is that lguest forgets to clear the TSC cpuid
bit when it disables TSC. Then the TSC frequency doesn't get computed
and sched-clock can divide by zero.That's purely a lguest bug that needs
to be fixed in lguest with a 
clear_bit(X86_FEATURE_TSC, &boot_cpu_data.x86_capability) 
somewhere

-Andi
 
