Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbXGPWbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbXGPWbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXGPWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:30:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759629AbXGPWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:30:05 -0400
Date: Mon, 16 Jul 2007 15:29:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
In-Reply-To: <20070716.150825.66176632.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0707161525250.20061@woody.linux-foundation.org>
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net>
 <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
 <20070716.150825.66176632.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, David Miller wrote:
> 
> Ingo is the only person hitting and reporting this and last time I
> checked he is competent enough to revert the thing locally in his own
> trees, right? :-)

Umm. And your suggestion is what? Wait until -rc1, when non-developers 
(the kinds of people who are supposed to *not* be competent enough) come 
along, and report the problem?

That's explicitly what I do *not* want to happen.

If we knew something was wrong before the -rc1 release, all the better: we 
can avoid havign that bug in -rc1, and the people who test it will tell us 
about the problems we did *not* know about.

In contrast, if we leave a known bug in, that will just mean that other 
problems won't be found either, because people get hung up on the known 
bug.

Regressions should be fixed early and often. Otherwise there's no point in 
making the code available early and often in the first place.

A regression is basically MUCH WORSE than just about any possible bug that 
patch could have fixed, and I want people to really think that way.

The rule for *everybody* should be:

	"Regressions get fixed immediately"

with no ifs, buts or maybes. In fact, it would be even better if the kinds 
of patches that cause regressions wouldn't hit my tree at all, but once 
they have hit it, and once they've been identified, they get reverted.

		Linus
