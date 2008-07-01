Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYGAHqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYGAHqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYGAHqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:46:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbYGAHqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:46:12 -0400
Date: Tue, 1 Jul 2008 09:45:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080701074547.GA16262@elte.hu>
References: <200807010148.02135.rjw@sisk.pl> <20080701072024.GB26601@elte.hu> <20080701002856.2457a75d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701002856.2457a75d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 1 Jul 2008 09:20:24 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > Hi,
> > > 
> > > The appended patch fixes a regression and is considered as 2.6.26 
> > > material. Everyone having a box with working suspend to RAM is gently 
> > > requested to test it and verify if it doesn't break things.
> > > 
> > > The patch applies to the current -git.
> > 
> > The fix is _really_ tempting, but i think it's 2.6.26.1 material at the 
> > earliest. I just counted about 8 red flag items in that commit:
> > 
> >   - "assembly code"
> >   - "fresh change"
> >   - "suspend/resume"
> >   - "real-mode code"
> >   - "ACPI"
> >   - "SMM"
> >   - "CPU erratas"
> >   - "boot code"
> > 
> > I'd say it's probably 90% fine, but it's just too much risk at this 
> > stage i think. The regression was only found 2 weeks ago, and the commit 
> > that broke it was upstream for 2 months (and was under testing for about 
> > 4 months).
> 
> Merge it into 2.6.27-rc1 and add Cc: <stable@kernel.org> to the changelog with
> a note "needed in 2.6.26.x after a couple of weeks testing in mainline" or
> something like that.

ok.

> I expect 2.6.25.x will be maintained for a while yet too...

2.6.25.x is not affected by the suspend+resume aspect of this problem.

	Ingo
