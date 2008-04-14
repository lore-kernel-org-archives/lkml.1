Return-Path: <linux-kernel-owner+w=401wt.eu-S1764809AbYDNSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764809AbYDNSJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYDNSJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:09:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5184 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbYDNSJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:09:15 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Oeser <ioe-lkml@rameria.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <1208195673.7164.2.camel@twins>
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org>
	 <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org>
	 <20080413070833.GC19773@elte.hu> <20080413125758.GQ11962@parisc-linux.org>
	 <20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com>
	 <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org>
	 <1208195673.7164.2.camel@twins>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 11:09:12 -0700
Message-Id: <1208196552.4877.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 19:54 +0200, Peter Zijlstra wrote:
> On Mon, 2008-04-14 at 19:46 +0200, Andi Kleen wrote:
> > Peter Zijlstra <peterz@infradead.org> writes:
> > >
> > > Yeah, I would open code it.  But this is indeed a sane usage of the
> > > counting semaphore because there is no priority inversion.
> > 
> > But when you open code that, how is it different from just having
> > semaphores? 
> 
> Because we can then eventually get rid of semaphores, so those people
> cannot mistakenly use them. Its just too easy to create prio inversion
> with them around.

I'm not for open coding anything .. This "writes in flight" type code
happens often enough we should have something that covers it..
completions come fairly close (since they're just like locked
semaphores) only it's not easy to initialize them to allow multiple
completes before the waiting starts..

Daniel

