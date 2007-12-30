Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbXL3RQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbXL3RQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXL3RQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:16:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbXL3RQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:16:13 -0500
Date: Sun, 30 Dec 2007 18:08:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230170826.GB16502@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu> <20071230160132.GA14311@elte.hu> <20071230164828.039916c8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230164828.039916c8@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > ah, i understand. So i guess a stupid udelay_serialized() which 
> > takes a global spinlock would solve these sort of races? But i guess 
> > making them more likely to trigger would lead to a better kernel in 
> > the end ...
> 
> Better to just fix the drivers. I don't think that will take too many 
> days after everyone is back working.

ok.

> > doing it - but we'll do the plunge in v2.6.25 and make 
> > io_delay=udelay the default, hm? Thomas has a real 386DX system, if 
> > that doesnt break
> 
> For processors with TSC I think we should aim for 2.6.25 to do this 
> and to have the major other _p fixups done. I pity whoever does stuff 
> like the scc drivers but most of the rest isn't too bad.

ok, sounds good to me. The current io_delay= stuff for v2.6.25 is 
already shaped as a debugging/transition helper, towards complete 
elimination of _p() uses.

	Ingo
