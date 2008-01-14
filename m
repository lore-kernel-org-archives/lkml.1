Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYANQcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYANQcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYANQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:32:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYANQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:32:29 -0500
Date: Mon, 14 Jan 2008 08:30:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
 Tracing
In-Reply-To: <20080114153505.GA11522@Krystal>
Message-ID: <alpine.LFD.1.00.0801140824430.2806@woody.linux-foundation.org>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu> <20080102163309.GC11496@redhat.com> <20080102170157.GA11161@elte.hu> <20080107185954.GA16041@Krystal>
 <20080113180740.GA4435@ucw.cz> <20080114153505.GA11522@Krystal>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jan 2008, Mathieu Desnoyers wrote:
> 
> We would have to figure out if enabling -freorder-blocks-and-partition
> makes sense kernel-wide.

Last I saw, it generates crappy code, with lots more jumps back and forth, 
and the image just blows up.

There's a reason we use -Os, and that's that small footprint I$ is 
generally more important than fake compiler optimizations that don't 
actually help except on microbenchmarks where everything fits in the 
cache.

Taking a branch instruction from two bytes to five is almost always a 
mistake, unless you *know* that the code it jumps to will effectively 
never be done at all (which is not necessarily the case at all). It also 
makes debugging much nastier, because if now things like backtraces 
probably look like crap too!

Don't go there. The *best* we can do is to just use the optimizations that 
generate good-looking code that humans can read. The rest is just compiler 
masturbation.

			Linus
