Return-Path: <linux-kernel-owner+w=401wt.eu-S1163263AbYCTA35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163263AbYCTA35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbYCSXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:52:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S943224AbYCSXw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:52:28 -0400
Date: Thu, 20 Mar 2008 00:52:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080319235212.GA22786@elte.hu>
References: <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E19085.2020308@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> simple bootup triggered it.
>
> Haven't managed to repro it yet, but DEBUG_PAGE_ALLOC turned up 
> another case of doing tlb flushes with preempt on:

turns out that i have another bug which causes a screaming IRQ#0 that 
floods the box at 70K irqs/sec. That is what triggered that crash in 
your patch most likely.

so either figure out the bug by review or try turning your IRQ#0 into a 
screaming one for debug purposes. (hint: turning irq#0's trigger mode 
from 'edge' to 'level' in mpparse.c or ioapic.c does wonders to that end 
;-)

	Ingo
