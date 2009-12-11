Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZLKMsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZLKMsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZLKMsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:48:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbZLKMsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:48:46 -0500
Date: Fri, 11 Dec 2009 13:48:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, peterz@infradead.org
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211124835.GB14509@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
 <20091211102316.GB16882@elte.hu>
 <20091211.023808.233094506.davem@davemloft.net>
 <20091211104126.GA22079@elte.hu>
 <20091211114858.GE4164@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211114858.GE4164@wear.picochip.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jamie Iles <jamie.iles@picochip.com> wrote:

> On Fri, Dec 11, 2009 at 11:41:26AM +0100, Ingo Molnar wrote:
> > > I think he did it this way so it can compile in the meantime, and that 
> > > doing it right requires runtime cpu detection to select which barrier 
> > > instruction is even available on the current ARM cpu.
> > 
> > Yeah. We can merge a quick patch for it if runtime detection is 
> > difficult - but if then such a patch should err on the side of using the 
> > barrier instruction unconditionally - even if this causes perf to 
> > segfault on certain (older? UP configured?) ARM cores.
>
> Ok, unless anyone has any objections, I'll post a revised patch that 
> uses the MCR instruction so that we get the correct behaviour on v6/v7 
> SMP and UP systems and an illegal instruction on v5 or earlier. I've 
> had a quick look at runtime detection and the ID registers are only 
> accessible from privileged modes so for long term, it might be better 
> to define the rmb() at build time from the kernel config.

Sounds good to me.

	Ingo
