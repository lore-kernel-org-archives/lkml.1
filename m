Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbYCDQXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbYCDQXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764595AbYCDQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:23:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764202AbYCDQXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:23:38 -0500
Date: Tue, 4 Mar 2008 17:23:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
Message-ID: <20080304162305.GA15100@elte.hu>
References: <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <1204630906.16613.4.camel@muff> <20080304143324.GA2713@elte.hu> <1204647331.2774.18.camel@muff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204647331.2774.18.camel@muff>
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


* Mark McLoughlin <markmc@redhat.com> wrote:

> > i'm wondering, what triggered this bug, and why didnt we have these 
> > problems in the past?
> 
> That's been bothering me too, but hadn't come up with anything until I 
> just now looked again.
> 
> I'm pretty certain that dmi_scan_machine() wasn't using a fixmap 
> before (in 2.6.24) since I had to fix a broken xen dom0 patch to 
> handle this new situation.

ah, ok, indeed Jeremy's gut feeling about early_ioremap() was right - we 
didnt use fixmaps for early_ioremap() [ ex. bt_ioremap() ] in .24. We 
try to slowly get rid of the linearity assumptions from arch/x86, this 
was one of the steps.

	Ingo
