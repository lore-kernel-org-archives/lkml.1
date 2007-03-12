Return-Path: <linux-kernel-owner+w=401wt.eu-S965410AbXCLJQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410AbXCLJQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXCLJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:16:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:33784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965410AbXCLJQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:16:48 -0400
Date: Mon, 12 Mar 2007 10:16:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312091628.GE28546@wotan.suse.de>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312091006.GF21024@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:10:06AM +0100, Ingo Molnar wrote:
> 
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > I agree it should restart.  But I don't think this is quite right in 
> > the timeout case.  It will increase the total maximum real time spent 
> > arbitrarily by the amount of time elapsed in signal handlers.  Other 
> > restartable, timed calls have to convert to an absolute timeout for 
> > the restart block (and convert back when doing the restart).
> 
> i dont think we should try to do this. We should not and cannot do 
> anything about all of the artifacts that comes with the use of relative 
> timeouts and schedule_timeout().
> 
> basically, using jiffies here (which schedule_timeout() does) is 
> /fundamentally/ imprecise. If you get many interrupts, rounding errors 
> sum up - and there's nothing we can do about it!

Well I did convert futex_wait to an absolute timeout based version in
the subsequent incremental patch. I think that is OK?
