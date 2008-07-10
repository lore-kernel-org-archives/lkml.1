Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYGJGxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYGJGxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYGJGxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:53:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYGJGxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:53:31 -0400
Date: Thu, 10 Jul 2008 08:53:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Message-ID: <20080710065316.GA14377@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092015.03004.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> fix phys_pmd_init to make sure not to return big value than end.
> 
> also print out range split:1G/2M/4K

applied to tip/x86/core, thanks Yinghai. Lets hope it all goes well, 
this is a rather scary change - but it's also fairly clean.

perhaps add a comment to the limit of 5 of mapping ranges - to point out 
that the number of mapping ranges depends on our programming, not on any 
external factor. I.e. if anyone adds a new mapping range to the kernel 
for any purpose, it must be extended - but otherwise it cannot run out 
due to new hardware.

	Ingo
