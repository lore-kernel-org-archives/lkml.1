Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbXBXQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbXBXQ4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXBXQ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:56:00 -0500
Received: from amsfep19-int.chello.nl ([62.179.120.14]:64787 "EHLO
	amsfep19-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519AbXBXQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:55:59 -0500
Subject: Re: [PATCH 18/29] netfilter: notify about NF_QUEUE
	vs	emergency	skbs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
In-Reply-To: <45E06A86.2060408@trash.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144843.299254000@taijtu.programming.kicks-ass.net>
	 <45E05954.8050204@trash.net> <1172332010.28579.6.camel@lappy>
	 <45E064FF.8010000@trash.net> <1172333937.6374.47.camel@twins>
	 <45E06A86.2060408@trash.net>
Content-Type: text/plain
Date: Sat, 24 Feb 2007 17:55:49 +0100
Message-Id: <1172336149.28579.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 17:40 +0100, Patrick McHardy wrote:
> Peter Zijlstra wrote:
> > On Sat, 2007-02-24 at 17:17 +0100, Patrick McHardy wrote:
> > 
> > 
> >>I don't really see why
> >>queueing is special though, dropping the packets in the ruleset
> >>will break things just as well, as will routing them to a blackhole.
> >>I guess the user just needs to be smart enough not to do this.
> > 
> > 
> > Its user-space and no emergency packet may rely on user-space because it
> > most likely is needed to maintain user-space.
> 
> I believe I might have misunderstood the intention of this patch.
> 
> Assuming the user is smart enough not to queue packets destined
> to a SOCK_VMIO socket, are you worried about unrelated packets
> allocated from the emergency reserve not getting freed fast
> enough because they're sitting in a queue? In that case simply
> dropping the packets would be fine I guess.

OK, that sounds good. I shall make NF_QUEUE a black hole for emergency
packets.

Alas, that leaves no way to warn a user about a SOCK_VMIO bound packet
treated this way, since, as you said, that is unknown at this point in
the chain.

Thanks,
Peter

