Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbXFVGxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbXFVGxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXFVGw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:52:58 -0400
Received: from mx10.go2.pl ([193.17.41.74]:47172 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbXFVGw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:52:57 -0400
Date: Fri, 22 Jun 2007 09:00:56 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [patch] spinlock debug: make looping nicer
Message-ID: <20070622070056.GA1778@ff.dom.local>
References: <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org> <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org> <20070621204234.GA1510@elte.hu> <alpine.LFD.0.98.0706211352530.3593@woody.linux-foundation.org> <20070621211525.GA9973@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621211525.GA9973@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 11:15:25PM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 21 Jun 2007, Ingo Molnar wrote:
> > > 
> > > btw., back then we also tried a spin_is_locked() based inner loop 
> > > but it didnt help the ->tree_lock lockups either. In any case i very 
> > > much agree that the 'nicer' looping should be added again - the 
> > > patch below does that. (build and boot tested)
> > 
> > Ok, I'm definitely not going to apply it right now, though.
> 
> yeah, very much so. Lots of distros ship with spinlock debugging enabled 
> (at least in their betas), we dont want to break that accidentally.

But, I hope, Miklos will manage to find some time to try this
patch or spinlock debugging on, to confirm the nature isn't
mocking us here... 

Miklos, I'd appreciate it very much if you could also exclude my
another extremely silly suspicion, and try with only cpu_relax()
instead of yield() (but without removing if (preempted)) in
wait_task_inactive().

Thanks & regards,
Jarek P.
