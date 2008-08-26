Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYHZKkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYHZKkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYHZKkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:40:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60451 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbYHZKkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:40:04 -0400
Date: Tue, 26 Aug 2008 12:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Mikael Pettersson <mikpe@it.uu.se>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [BUG] get_rtc_time() triggers NMI watchdog in
	hpet_rtc_interrupt()
Message-ID: <20080826103921.GB10144@elte.hu>
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se> <19f34abd0808240214o22748804s45e8487d62b34cb8@mail.gmail.com> <18609.14516.873317.52292@harpo.it.uu.se> <19f34abd0808240448w5facaee2gec77662c14b9364f@mail.gmail.com> <48B3DA02.9080002@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B3DA02.9080002@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> I beat you :-).  I noticed the problem myself.  It does trigger if I 
> run hwclock in a loop.
> 
> while true; do hwclock; done
> 
> However it is fine in latest git.  Looks like Ingo's patch has been 
> merged, and has fixed it.

ah, good - thanks for testing it. I havent seen a lockup on the T60 
either - but it was very sporadic to begin with. (and now we understand 
why: hwclock is running only once per reboot.)

Plus, the real bug has to be found as well: who in the rtc ioctl path 
calls this code with irqs disabled - it's not nice.

	Ingo
