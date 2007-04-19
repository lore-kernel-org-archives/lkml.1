Return-Path: <linux-kernel-owner+w=401wt.eu-S1031196AbXDSIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031196AbXDSIWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031208AbXDSIWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:22:30 -0400
Received: from mx10.go2.pl ([193.17.41.74]:58649 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031184AbXDSIW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:22:27 -0400
Date: Thu, 19 Apr 2007 10:28:02 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070419082802.GA2425@ff.dom.local>
References: <20070419065404.GB1782@ff.dom.local> <20070419073222.GA438@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419073222.GA438@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:32:22AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > +		int i = 1000;
> >  
> > -		while (!cancel_delayed_work(dwork))
> > +		while (!cancel_delayed_work(dwork)) {
> >  			flush_workqueue(wq);
> > +			BUG_ON(!i--);
> > +		}
> 
> if then make it a WARN_ON(). But ... dont we have the softlockup 
> detector for such cases? Does CONFIG_DETECT_SOFTLOCKUP=y give you enough 
> information?

Maybe it was my testing, but no softlockup detection triggered here.
I'll try to wait longer - and if no result - I'll resubmit tomorrow.

On the other hand, I think the return of cancel_delayed_work is
too much depending on probability here (it may look like shooting
to running targets), so it could be hard to repeat (and debugging
not necessarily on at the time). As a matter of fact I intentionally
made it for -mm, to see if the problem really exists, because then,
another solution is needed.

And of course WARN_ON should be better - if only it's messages were
more reliably saved in logs after rebooting.

Jarek P.
