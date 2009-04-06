Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZDFJZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZDFJZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZDFJZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:25:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbZDFJZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:25:26 -0400
Date: Mon, 6 Apr 2009 11:25:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [crash, bisected] net, sky2: BUG: unable to handle kernel NULL
	pointer dereference, pci_vpd_truncate()
Message-ID: <20090406092517.GA4405@elte.hu>
References: <20090406090303.GA12525@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406090303.GA12525@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Not sure whether this has been reported before, but one of the 
> -tip testboxes started showing the boot crash attached below. 
> Reproduces with latest -git.
> 
> I have bisected it to:
> 
> | installing & booting kernel ... => good. (114 seconds)
> | 3834507d0c5480a0f05486c2fb57ed18fd179a83 is first bad commit
> | commit 3834507d0c5480a0f05486c2fb57ed18fd179a83
> | Author: Stephen Hemminger <shemminger@vyatta.com>
> | Date:   Tue Feb 3 11:27:30 2009 +0000
> |
> |     sky2: set VPD size
> |    
> |     Read configuration register during probe and use it to size the
> |     available VPD. Move existing code using same register slightly
> |     earlier in probe handling.
> 
> [ I'm testing the straight revert currently. Can send more info if 
>   needed. ]

The revert solved the crash.

	Ingo
