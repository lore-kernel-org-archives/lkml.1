Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXDDUqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXDDUqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXDDUqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:46:13 -0400
Received: from www.osadl.org ([213.239.205.134]:33962 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbXDDUqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:46:11 -0400
Subject: Re: [PATCH -mm] fix jiffies clocksource inittime
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>
In-Reply-To: <20070404134310.12ad3ab8.akpm@linux-foundation.org>
References: <1175716216.17711.59.camel@localhost>
	 <20070404134310.12ad3ab8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 22:46:29 +0200
Message-Id: <1175719589.28263.315.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 13:43 -0700, Andrew Morton wrote:
> >  
> > -module_init(init_jiffies_clocksource);
> > +core_initcall(init_jiffies_clocksource);
> 
> Do you think this is needed in 2.6.21?

Yes, please.

> If so: worrisome.  Startup ordering issues are fragile and tricky.  Time
> management is fragile and tricky.  The combination of the two doesn't get
> any better ;)
> 
> An option would be to test it in 2.6.22-rcX for a while, then backport to
> 2.6.21.x.

The jiffies clocksource is completely uncritical and it's less worrisome
than having the TSC early as the time reference.

	tglx


