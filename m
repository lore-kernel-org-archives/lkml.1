Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYLPQuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYLPQuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbYLPQun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:50:43 -0500
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:34482 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114AbYLPQun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:50:43 -0500
Date: Tue, 16 Dec 2008 11:55:27 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <1229438579.7025.21.camel@twins>
Message-ID: <Pine.LNX.4.64.0812161149430.6141@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu>  <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
  <18758.53072.197695.277198@cargo.ozlabs.ibm.com> <1229438579.7025.21.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 2008-12-16 at 08:42 +1100, Paul Mackerras wrote:
> Furthermore, I think output of tools such as time and now timec are most
> relevant when compared between runs - that is, the change in values
> between runs, not the absolute values as such. At least, that's what I
> usually do:

That's doesn't do you any good when comparing results across different 
machines, or even different kernels on the same machine.

perfmon shows that good results can be had, even if it's not the cleanest 
way in the world.  It would be a shame to lose that.

Small micro-benchmarks like this are important.  You can't always trust 
the performance counters to work, so being able to sanity check them with 
exact test-cases is critical.  Otherwise you might just be measuring 
nonsense.

And while it might be able to subtract the exec() overhead for something 
like retired instructions, it gets a lot more complicated when you have 
something like cache bus snoops or branch mispredicts where it's hard to 
tell what comes from the program and what is overhead from the monitoring 
infrastructure.

Vince
