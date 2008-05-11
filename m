Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYEKOc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYEKOc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEKOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:32:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37242 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYEKOcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:32:47 -0400
Date: Sun, 11 May 2008 16:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511143227.GA3220@elte.hu>
References: <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511135414.GA2328@elte.hu> <20080511142222.GU19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511142222.GU19219@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> > the gain is rather obvious: two parallel up()s (or just up()s which 
> > come close enough after each other) will wake up two tasks in 
> > parallel. With your patch, the first guy wakes up and then it wakes 
> > up the second guy. I.e. your patch serializes the wakeup chain, mine 
> > keeps it parallel.
> 
> Yup.  I explained why that's actually beneficial in an earlier email.

but the problem is that by serializing the wakeup chains naively you 
introduced a more than 50% AIM7 performance regression.

	Ingo
