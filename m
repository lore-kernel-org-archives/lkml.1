Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbYARPBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbYARPBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYARPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:00:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbYARPAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:00:53 -0500
Date: Fri, 18 Jan 2008 16:00:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] x86: Use v8086_mode helper, trivial unification
Message-ID: <20080118150040.GB31446@elte.hu>
References: <1200615957.5724.75.camel@brick> <20080118091208.GE24337@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118091208.GE24337@elte.hu>
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


> > +	/*
> > +	 * Did it hit the DOS screen memory VA from vm86 mode?
> > +	 */
> > +	if (v8086_mode(regs)) {
> > +		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
> > +		if (bit < 32)
> > +			tsk->thread.screen_bitmap |= 1 << bit;
> > +	}

this does not build on 64-bit, because screen_bitmap is 32-bit only - so 
i had to pull the patch. I suspect a small #ifdef section would look 
better here?

	Ingo
