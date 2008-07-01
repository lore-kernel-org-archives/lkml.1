Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYGALTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYGALTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYGALTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:19:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYGALTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:19:45 -0400
Date: Tue, 1 Jul 2008 13:19:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       florian.fainelli@telecomint.eu,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Message-ID: <20080701111918.GA11809@elte.hu>
References: <200807011249.40551.mb@bu3sch.de> <20080701110436.GA32365@elte.hu> <200807011313.40598.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011313.40598.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> > ... and thus perhaps your GPIO_USERSELECTION patch should move into 
> > drivers/ and be generally accessible, not special to x86?
> 
> Yes I'd really like to move it there, too. But currently that clashes 
> with architectures like MIPS, some PPC flavours and probably others 
> that implement their own GPIO API. We should have an 
> ARCH_IMPLEMENT_GPIO or whatever, but currently we don't seem to have 
> that.
> 
> So well. If it's desired to put the user selection into drivers/gpio 
> (which I'd really prefer), I can try to make a patch that adds 
> ARCH_IMPLEMENT_GPIO to every arch that implements their own GPIO API 
> and make GPIO_USERSELECTION depend on !ARCH_IMPLEMENT_GPIO.

or we could try it the other way around: stick 
ARCH_ALLOWS_TRULY_GENERAL_PURPOSE_INPUT_OUTPUT (note: please use a 
better name ;-) into x86, add the user text to drivers/ and let other 
architectures enable it too?

That way your commits would still be pretty focused (you'd avoid having 
to touch a lot of architectures) and it would still work all across the 
spectrum.

hm?

	Ingo
