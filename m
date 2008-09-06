Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYIFRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYIFRzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYIFRzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:55:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbYIFRzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:55:37 -0400
Date: Sat, 6 Sep 2008 19:55:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
Message-ID: <20080906175521.GX4856@elte.hu>
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com> <20080829063012.GA19459@elte.hu> <alpine.LFD.1.10.0808290824070.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808290824070.3300@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 29 Aug 2008, Ingo Molnar wrote:
> > 
> >  BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
> >  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> > 
> > which overlaps with the chipset PCI BAR (hpet) resource:
> > 
> >    pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
> > 
> > so due to this 1K conflict we take the full e820-reserved entry out and 
> > give the range 0xfec00000-0x100000000 as 'free'.
> 
> That's wrong. It's a full overlap, so "insert_resource()" should 
> happily insert the 00000000fec00000 - 0000000100000000 _around_ the 
> HPET bar.
> 
> Do you actually see this behavior, or do you just misunderstand how 
> "insert_resource()" works?

the latter, i misunderstood how it works.

	Ingo
