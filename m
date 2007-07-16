Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbXGPVvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbXGPVvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXGPVv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:51:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764264AbXGPVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:51:27 -0400
Date: Mon, 16 Jul 2007 23:51:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070716215117.GA25097@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net> <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

>    With MSI, edge-triggered interrupts are making a comeback in a big 
>    way, and yeah, e1000 is one of the drivers that do MSI. Ingo might 
>    want to confirm whether it's actually enabled for him, and whether 
>    turning it off might hide the problem, but if that's it, then the 
>    whole patch is fundamentally broken, and not worth saving.

MSI was off for the test:

  # CONFIG_PCI_MSI is not set

full config is at:

  http://redhat.com/~mingo/misc/config

the hang-log is at:

  http://redhat.com/~mingo/misc/hang.log

netconsole output went silent during the last tx-timeout message. (the 
above hang.log is from dmesg)

> but in either case (or, indeed, even if I didn't see any problem at 
> all), I think reverting a patch that isn't needed is _always_ the 
> right choice.
> 
> If we don't know what caused a problem in the first place, or if the 
> fix is known to be required for something else and reverting it would 
> cause *another* regression, it would be another issue. But as it is, 
> reverting it would seem to unquestionably get rid of a regression, and 
> is thus a no-brainer.
> 
> No?

i also offered to quickly try any test-version of the fixed patch, so 
there's a real and deterministic path towards fixing the patch. The 
regression is obvious and triggers all the time.

	Ingo
