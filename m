Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZJATCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZJATCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZJATCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:02:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZJATCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:02:18 -0400
Date: Thu, 1 Oct 2009 21:02:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing fixes
Message-ID: <20091001190210.GA23159@elte.hu>
References: <20090921130228.GA25588@elte.hu> <alpine.LFD.2.01.0909210908020.4950@localhost.localdomain> <20090921162211.GA844@elte.hu> <20090926161034.GA17279@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926161034.GA17279@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Sep 21, 2009 at 06:22:11PM +0200, Ingo Molnar wrote:
> > Hm, yes, you are right, we missed that. I noticed the modpost 
> > dependency:
> > 
> >   http://marc.info/?l=linux-kernel&m=125326944223679&w=2
> > 
> > but thought that it's safe and didnt notice that dangling 
> > module_layout() reference and the build warning it generates in the 
> > kernel.
> > 
> > I _think_ the patch below should do the trick - module_layout() appears 
> > to be an artificial symbol with 'significant' symbols listed in its 
> > argument list so that it gets a proper signature. Removing the marker 
> > symbol should thus be the solution, but i'm not 100% sure. Thoughts?
> > 
> > 	Ingo
> 
> Looks good to me, Linus?
> 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index b6ee424..392eb3d 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2947,7 +2947,6 @@ void module_layout(struct module *mod,
> >  		   struct modversion_info *ver,
> >  		   struct kernel_param *kp,
> >  		   struct kernel_symbol *ks,
> > -		   struct marker *marker,
> >  		   struct tracepoint *tp)
> >  {
> >  }
> ---end quoted text---

Yep, already pushed that to Linus some time ago:

  115e8a2: modules, tracing: Remove stale struct marker signature from module_layout()

	Ingo
