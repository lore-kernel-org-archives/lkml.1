Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXKOLDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXKOLDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765033AbXKOLDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:03:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbXKOLDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:03:40 -0500
Date: Thu, 15 Nov 2007 12:03:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071115110325.GA15109@elte.hu>
References: <20071114233713.GW19691@waste.org> <20071114.154143.112110604.davem@davemloft.net> <20071115104331.GA11390@elte.hu> <20071115.025158.254212538.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115.025158.254212538.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> Yeah I wish udev would just leave the damn devices alone.
> 
> It even does things like try to rename a network device to the same 
> name it already has, and other strange stuff.
> 
> But that log difference is a good clue.
> 
> Because udev can try to rename a network device stupidly to a name the 
> device already has we added a patch to just short circuit this case in 
> the networking.  We did this because otherwise the generic device 
> layer gives an ugly stack backtrace via dev_rename().
> 
> Therefore, you might want to see if reverting that patch (attached 
> below) has some effect, once you are able to trigger it again.

just to confuse things, i just got a crash with the twiddled network 
setup :-/ I have reverted the same-name optimization and have got a 
similar crash again. So this angle is a red herring.

now that it's reproducible again i'll try more direct debugging. 
(Networking might not even be the cause of this - that was just a quick 
first impression that i had.)

Btw., the .config is the result of automated "make randconfig" x86 
bootup testing QA, so there might be weird combinations in the .config. 
That's how SLOB got randomly enabled in the first place, i dont normally 
use SLOB kernels.

	Ingo
