Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbZDBSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbZDBSdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZDBSd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:33:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZDBSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:33:26 -0400
Subject: Re: [PATCH 2/6] RFC perf_counter: singleshot support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402181026.GA6340@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.257773792@chello.nl> <1238674691.8530.5948.camel@twins>
	 <20090402181026.GA6340@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 20:33:17 +0200
Message-Id: <1238697197.5133.49.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:10 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > OK, so I just remembered the sigio thing mentioned by Paul a while 
> > back.
> > 
> > and this should do I suppose...
> 
> > @@ -1561,6 +1578,7 @@ void perf_counter_wakeup(struct perf_cou
> >  	rcu_read_unlock();
> >  
> >  	wake_up_all(&counter->waitq);
> > +	kill_fasync(&counter->fasync, SIGIO, POLL_IN);
> 
> ah, yes.
> 
> Do we even need the explicit signo method this way? The SIGIO target 
> is configurable via fcntl(F_SETSIG), right?

F_SETSIG allows you to change the signal that is delivered, SIGIO by
default, F_SETOWN allows you to specify a target.



