Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbYDPMuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbYDPMuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbYDPMup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:50:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbYDPMuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:50:44 -0400
Message-ID: <4805F61A.1060306@firstfloor.org>
Date: Wed, 16 Apr 2008 14:50:34 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
References: <4803AD91.5020001@firstfloor.org> <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com> <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <20080415170556.GA16417@elte.hu> <20080415185008.GE9191@parisc-linux.org> <20080416123732.GA32527@elte.hu>
In-Reply-To: <20080416123732.GA32527@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> btw., has anyone thought about killable sync/fsync syscalls - would that 
> surprise too many programs?

killable stat and readdir would be even more important I would say.

When sync/fsync takes too long it's typically just a kernel bug
of some sort (like that long running MM starvation issue that stalls
writes on some kinds of background activity) that should be really just
fixed.

But handling down network servers which hit stat/readdir etc. is
a real situation not explained by a bug.

For example a standard situation that hits me regularly is that
I save something in firefox on a different server and then later
turn that machine off. Then next time I try to save something
in firefox it first blocks forever in stat()ing that down directory.

-Andi

