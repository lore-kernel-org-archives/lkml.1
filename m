Return-Path: <linux-kernel-owner+w=401wt.eu-S935345AbXGRRYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935345AbXGRRYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXGRRYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:24:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbXGRRYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:24:14 -0400
Date: Wed, 18 Jul 2007 10:23:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Ian Kent <raven@themaw.net>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] CFS scheduler, -v19
In-Reply-To: <20070718075417.GA7895@elte.hu>
Message-ID: <alpine.LFD.0.999.0707181019570.27353@woody.linux-foundation.org>
References: <MDEHLPKNGKAHNMBLJOLKKEBPFGAC.davids@webmaster.com>
 <1184738344.4178.18.camel@raven.themaw.net>
 <20070718075417.GA7895@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Ingo Molnar wrote:
> 
> Linus, Thomas, what do you think, should we keep the time.c change? 

No, not if it's off by the second field. That 30% CPU usage indicates that 
there's some nasty bug there somewhere, and that's just not worth it.

If time() cannot get the second field right, it's bogus. I'm ok with us 
not *guaranteeing* monotonicity of the second field when you compare 
gettimeofday() with time(), but the 30% thing implies that it's much worse 
than that, and that "time()" will likely report the previous second (when 
compared to hrtimers) roughly a quarter of the time.

And that isn't acceptable. 

So either it should be fixed, or reverted.

		Linus
