Return-Path: <linux-kernel-owner+w=401wt.eu-S1764062AbYAaPIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764062AbYAaPIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYAaPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:08:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbYAaPIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:08:14 -0500
Date: Thu, 31 Jan 2008 16:07:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Add a list for custom page fault handlers.
Message-ID: <20080131150746.GB11996@elte.hu>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi> <1201660102.8837.9.camel@brick> <1201660453.8837.13.camel@brick> <20080130200827.322c4f7d@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130200827.322c4f7d@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> >  static inline int notify_page_fault(struct pt_regs *regs)
> >  {
> >  #ifdef CONFIG_KPROBES
> > @@ -588,6 +636,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  	if (notify_page_fault(regs))
> >  		return;
> >  
> > +	if (handle_custom_pf(regs, error_code, address))
> > +		return;
> > +
> 
> This is the non-trivial change that I really want to test before 
> submitting again. The call site of the handlers changes, and vmalloc 
> related faults reach the custom handlers. I don't think this would be 
> a problem for mmiotrace, but I don't know enough to be sure. I guess 
> using vmalloc'd memory from a page fault handler would be doomed, 
> anyway, so no point worrying about it, right?

could you please send us a patch for the whole mmiotrace kernel-side 
feature, so that we can have a look at the general structure of this? 
(and the interaction with change_page_attr(), etc.) Even if it's not 
functional (and wont even build/boot) at the moment. Thanks,

	Ingo
