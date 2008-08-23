Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYHWUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYHWUa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYHWUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:30:21 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:40639 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbYHWUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:30:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjwFAA8KsEhMRKxB/2dsb2JhbACBZbJdgWg
Date: Sat, 23 Aug 2008 16:30:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
Message-ID: <20080823203016.GA1328@Krystal>
References: <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal> <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org> <20080823050916.GA1172@Krystal> <alpine.LFD.1.10.0808231100090.3363@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808231100090.3363@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:26:13 up 80 days,  1:06,  4 users,  load average: 0.27, 0.39,
	1.07
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Sat, 23 Aug 2008, Mathieu Desnoyers wrote:
> > 
> > Now, let me explain why I need at least not one, but _four different_
> > contention bits. Simply because there are four types of contention, one
> > for each execution context which may take the read lock. (irq, softirq,
> > non-preemptable, preemptable)
> 
> No. You need _one_ contention bit in the fast-path.
> 
> Then, as you get into the slow-path, you can decide on four different 
> behaviours.
> 
> Quite frankly, I don't think this discussion is going anywhere. I don't 
> think I'd take anything from you, since you seem to have a really hard 
> time separating out the issue of fast-path and slow-path. So I'm simply 
> not going to bother, and I'm not going to expect to merge your work. 
> 
> Sorry, but it simply isn't worth my time or effort.
> 
> 			Linus

Hi,

OK, I now see how I can apply this contention bit idea to my algo.
Actually, the point I just fixed in my head is that this bit will be a
"MAY_CONTEND" bit, which could let higher priority readers access the
lock in the slow path. Only one fast path reader count will be required,
just as you said.

Sorry about taking that much time to get my head around this. Thanks for
your helpful explanations and your time.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
