Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZKRKTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZKRKTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZKRKTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:19:48 -0500
Received: from www.tglx.de ([62.245.132.106]:41895 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZKRKTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:19:47 -0500
Date: Wed, 18 Nov 2009 11:19:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <npiggin@suse.de>
cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -rt dbench scalabiltiy issue
In-Reply-To: <20091118042516.GC21813@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0911181110430.24119@localhost.localdomain>
References: <1255723519.5135.121.camel@localhost.localdomain> <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost> <20091118042516.GC21813@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

On Wed, 18 Nov 2009, Nick Piggin wrote:
> > So yes, on -rt, the overhead from lock contention is way way worse then
> > any extra atomic ops. :)
> 
> How about overhead for an uncontended lock? Ie. is the problem caused
> because lock *contention* issues are magnified on -rt, or is it
> because uncontended lock overheads are higher? Detailed callgraph
> profiles and lockstat of +/-atomic case would be very interesting.

In the uncontended case we have the overhead of calling might_sleep()
before we acquire the lock with cmpxchg(). The uncontended unlock is a
cmpxchg() as well.

I don't think that this is significant overhead and we see real lock
contention issues magnified by at least an order of magnitude.

Thanks,

	tglx
