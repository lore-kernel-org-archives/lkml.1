Return-Path: <linux-kernel-owner+w=401wt.eu-S1422839AbXBAMph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422839AbXBAMph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422840AbXBAMph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:45:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422839AbXBAMph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:45:37 -0500
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [-mm patch] x86_64 GTOD: offer scalable vgettimeofday II
Date: Thu, 1 Feb 2007 13:45:14 +0100
User-Agent: KMail/1.9.5
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com, Andrew Morton <akpm@osdl.org>
References: <20070201095952.589234000@jet.suse.cz> <200702011317.45876.ak@suse.de> <20070201122433.GA5255@elte.hu>
In-Reply-To: <20070201122433.GA5255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011345.14708.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 13:24, Ingo Molnar wrote:

> if resolution is an issue then i can improve this thing to be based off 
> a separate /optional/ hrtimer, thus if it's enabled it could enable 1000 
> Hz (and not 1024 Hz) update for the variable. The update resolution 
> could be tuned via a sysctl trivially, so everyone could tune the 
> resolution of this to the value desired, and could do so runtime.

It would be better to let the application set it without root rights 
(afaik W. allows this).  Auto tuning beats explicit configuration anytime.

Not sure it's really worth it though.

My thinking was to gather more requirements of what users actually
want first before adding all these new modi.

> [ It could also be driven by the database right now: from a thread open 
>   /dev/rtc, set it to 1024 HZ, and do a gettimeofday() call in every 
>   tick - that will auto-update the timestamp. ]

zmailer used to do that (or probably still does) but I always hated
the scheme for some reason :)


> > [...] But that would also make everything slower again due to CPU 
> > overhead as it was learned in the 2.4->2.6 HZ transition.
> 
> note that this cost was measured on UP and on older hardware, and the 
> cost of having a global 1000 Hz update gets linearly cheaper with the 
> increase of CPUs on SMP: because only one such update has to be running. 
> The systems those database vendors are interested in typically have a 
> fair number of CPUs.

Good point. Even on desktop with Multi Core or SMT it should be cheaper now.

-Andi
