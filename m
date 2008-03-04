Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbYCDMgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbYCDMgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYCDMgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:36:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYCDMgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:36:31 -0500
Date: Tue, 4 Mar 2008 13:36:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080304123602.GC29777@elte.hu>
References: <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303205227.GU17932@hjernemadsen.org>
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


* Klaus S. Madsen <ksm@hjernemadsen.org> wrote:

> So while I'm fairly confident in that I bisected correctly, the number 
> of attempts I had to go through to get a reliable result, and the fact 
> that I cannot make the problem go away by reverting the current code 
> to something similar, counts quite a lot against me.
> 
> However I'm 100% confident that the problem appears between 
> cf8fa920cb4271f17e0265c863d64bea1b31941a and 
> 925596a017bbd045ff711b778256f459e50a119, which is something like 16 
> commits. I have been at both points in the tree at least 2 times, and 
> confirmed that cf8fa920cb4271f17e0265c863d64bea1b31941a worked for me, 
> and 925596a017bbd045ff711b778256f459e50a119 didn't.

my guess would be that it's this commit that causes it:

| commit 6c3866558213ff706d8331053386915371ad63ec
| Author: Jeremy Fitzhardinge <jeremy@goop.org>
| Date:   Wed Jan 30 13:32:55 2008 +0100
|
|    x86: move all asm/pgtable constants into one place

> But I'm a bit puzzled by the fact that I'm aparently the only one how 
> have encountered the problem? Maybe it's only a problem if one also 
> uses PAE? (Thats just a wild guess to explain why I'm the only one 
> seeing this).

PAE activates NX on 32-bit. So we probably had an NX regression that got 
fixed by the side-effects of one of the unifications. Does it start 
working if you disable NX via the noexec=off boot option?

	Ingo
