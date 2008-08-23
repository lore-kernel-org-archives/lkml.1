Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYHWSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYHWSDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYHWSDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 14:03:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYHWSDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 14:03:33 -0400
Date: Sat, 23 Aug 2008 11:02:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
In-Reply-To: <20080823050916.GA1172@Krystal>
Message-ID: <alpine.LFD.1.10.0808231100090.3363@nehalem.linux-foundation.org>
References: <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal>
 <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal> <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org>
 <20080823050916.GA1172@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Mathieu Desnoyers wrote:
> 
> Now, let me explain why I need at least not one, but _four different_
> contention bits. Simply because there are four types of contention, one
> for each execution context which may take the read lock. (irq, softirq,
> non-preemptable, preemptable)

No. You need _one_ contention bit in the fast-path.

Then, as you get into the slow-path, you can decide on four different 
behaviours.

Quite frankly, I don't think this discussion is going anywhere. I don't 
think I'd take anything from you, since you seem to have a really hard 
time separating out the issue of fast-path and slow-path. So I'm simply 
not going to bother, and I'm not going to expect to merge your work. 

Sorry, but it simply isn't worth my time or effort.

			Linus
