Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbZDQBrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbZDQBrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZDQBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:47:47 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:57201 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbZDQBrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:47:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAMF750lMQW1W/2dsb2JhbACBTs5bg30G
Date: Thu, 16 Apr 2009 21:47:33 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
Message-ID: <20090417014733.GB24956@Krystal>
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090417014209.GA24956@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:44:02 up 47 days, 22:10,  1 user,  load average: 0.91, 0.55,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:
> > 
> > > I don't think this helps.  rcupdate_types.h uses preempt_disable/enable, but
> > > doesn't include linux/preempt.h for them - but someone's going to have to, so
> > > you've got an implicit dependency on the user to #include the right headers in
> > > advance.
> > 
> > Would including linux/preempt.h in rcupdate_types.h be a problem?
> > 
> > -- Steve
> > 
> 
> I did not include preempt.h in rcupdate_types.h because rcupdate.h did
> not include it, so I thought it had a special status such a kernel.h.
> However, I notice the rcupdate.h includes spinlock.h, which in turn
> includes preempt.h, so we would need to include preempt.h in
> rcupdate_types.h.
> 

Hrm, well, the actual question is :

given rcupdate_types.h only defines macros, and given we won't want to
include all the headers that implement all the content of these macros,
does it make sense to typically require people to either include
rcupdate.h directly if they want to have the full includes required to
expand the macros ?

If we do that, then including preempt.h in rcupdate_types.h is not
necessary. However, tracepoint.h should now include preempt.h, because
it would be cumbersome to require from every tracepoint.h users to
include preempt.h.

One way or another, we will have to include preempt.h under
tracepoint.h, but I don't see it as a roadblock, given that preempt.h is
quite slim.

Mathieu

> But I think preempt.h is pretty much only type definitions. I don't
> think that would be a problem, but maybe Jeremy knows better.
> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
