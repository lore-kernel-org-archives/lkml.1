Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbYKMIhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbYKMIhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYKMIg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:36:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYKMIgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:36:55 -0500
Date: Thu, 13 Nov 2008 09:36:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace: do not update max buffer with no users
Message-ID: <20081113083616.GB25479@elte.hu>
References: <20081113013041.086583690@goodmis.org> <20081113013247.974941878@goodmis.org> <20081112183745.07af124d.akpm@linux-foundation.org> <alpine.DEB.1.10.0811122140590.7458@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811122140590.7458@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 12 Nov 2008, Andrew Morton wrote:
> > This sort of thing:
> > 
> > +#ifdef CONFIG_TRACER_MAX_TRACE
> >  	if (current_trace && current_trace->print_max)
> >  		iter->tr = &max_tr;
> >  	else
> > +#endif
> >  		iter->tr = inode->i_private;
> > 
> > is particularly regrettable.
> 
> Yeah, I know it is particularly ugly :-(
> 
> I was hoping to spend some time to find a way to clean it up. The 
> other answer is to just scrap the config all together, and let the 
> unused max latency tracer buffer be allocated and take up space 
> (with no users).

Correct. That would also result in a smaller patch for .28, right?

	Ingo
