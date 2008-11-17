Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYKQU6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYKQU6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYKQU63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:58:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46728
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbYKQU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:58:28 -0500
Date: Mon, 17 Nov 2008 12:58:26 -0800 (PST)
Message-Id: <20081117.125826.193693115.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811171218470.18283@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org>
	<20081117.121641.167690467.davem@davemloft.net>
	<alpine.LFD.2.00.0811171218470.18283@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Nov 2008 12:30:00 -0800 (PST)

> On Mon, 17 Nov 2008, David Miller wrote:
> > 
> > It's on my workstation which is a much simpler 2 processor
> > UltraSPARC-IIIi (1.5Ghz) system.
> 
> Ok. It could easily be something like a cache footprint issue. And while I 
> don't know my sparc cpu's very well, I think the Ultrasparc-IIIi is super- 
> scalar but does no out-of-order and speculation, no?

I does only very simple speculation, but you're description is accurate.

> So I could easily see that the indirect branches in the scheduler
> hurt much more, and might explain why the x86 profile looks so
> different.

Right.

> One thing that non-NMI profiles also tend to show is "clumping", which in 
> turn tends to rather excessively pinpoint code sequences that release the 
> irq flag - just because those points show up in profiles, rather than 
> being a spread-out-mush. So it's possible that Ingo's profile did show the 
> scheduler more, but it was in the form of much more spread out "noise" 
> rather than the single spike you saw. 

Sure.
