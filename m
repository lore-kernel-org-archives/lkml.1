Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYJCKCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYJCKCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYJCKCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:02:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYJCKCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:02:33 -0400
Date: Fri, 3 Oct 2008 12:02:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
       lrodriguez@atheros.com
Subject: Re: ath9k: panic on tip/master
Message-ID: <20081003100211.GA29841@elte.hu>
References: <f488382f0810030256x2859fbf6j3f657621c567287f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810030256x2859fbf6j3f657621c567287f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0041]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> Hey folks,
> 
> Just got a panic on tip. According to the stack trace, ath9k is what 
> decided to bomb.
> 
> http://www.uplinklabs.net/~tycho/linux/ath9k_panic_tip_10.3.2008.jpg
> 
> Note: Although it says 'sudo modprobe radeon' on the bash prompt above 
> the panic, I never got to hit 'enter' on that command before the panic 
> occurred.

it appears to me that ath9k's eth_rx_input() takes a spinlock that is 
not initialized (or already destroyed by the allocator).

this would be consistent with an IRQ storm hitting some race in the 
ath9k driver init sequence. For example if request_irq() is done before 
all structures that the IRQ handler relies on are properly initialized.

i.e. this has the signature of a genuine ath9k bug.

	Ingo
