Return-Path: <linux-kernel-owner+w=401wt.eu-S934245AbXFFBLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbXFFBLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXFFBLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:11:14 -0400
Received: from ozlabs.org ([203.10.76.45]:48558 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522AbXFFBLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:11:13 -0400
Subject: Re: [PATCH 2/6] lguest tsc fix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070605181510.GA7782@muc.de>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
	 <20070605181510.GA7782@muc.de>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 10:25:49 +1000
Message-Id: <1181089549.14054.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 20:15 +0200, Andi Kleen wrote:
> On Wed, Jun 06, 2007 at 12:56:36AM +1000, Rusty Russell wrote:
> > In recent -mm kernels, the TSC capability cannot be disabled,
> > resulting in a divide by zero error in the normal sched_clock.
> 
> That will hopefully change. I hope hpa will just undo this.
> 
> > 
> > The correct fix is to have a special lguest sched_clock
> > implementation: this is as simple as it gets.
> 
> But gettimeofday might still use it. Is that ok for you?

Yes, I don't think it will be any worse than before.  Basically the
guest uses a dumb jiffies-based clock.  The TSC patch later in this same
series changes it back to use the native sched_clock, and overrides
tsc_khz instead (based on information from the host).

Thanks,
Rusty.


