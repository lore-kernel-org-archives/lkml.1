Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXDLUP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXDLUP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXDLUP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:15:26 -0400
Received: from mail.suse.de ([195.135.220.2]:51376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXDLUPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:15:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 22:15:04 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <200704121945.54053.ak@novell.com> <461E8CAA.3020902@goop.org>
In-Reply-To: <461E8CAA.3020902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122215.04499.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> They could be huge differences - unbounded, in fact.  It would make
> printk fairly hard to interpret,  I would think.  The only benefit to
> using sched_clock in printk is that if you're using it to work out the
> startup latencies you won't be confused by stolen time.  But I think
> that's a fairly small benefit compared to the disadvantage of not being
> able to meaningfully compare the timestamps on two printk messages.

Ok so the right solution would be a separate printk_clock() that is
implemented as the native sched_clock() even on Xen/VMI.  Should be a SMOP.

-Andi
