Return-Path: <linux-kernel-owner+w=401wt.eu-S1030383AbXCHJLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383AbXCHJLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030381AbXCHJLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030380AbXCHJLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:11:00 -0500
Date: Thu, 8 Mar 2007 10:10:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hardwired VMI crap 
Message-ID: <20070308091019.GA19460@elte.hu>
References: <45EE1EA3.90803@vmware.com> <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei> <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EF49E9.7040509@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> The correct solution here is to properly separate the APIC, SMP, and 
> timer code so the logic of it which we want to reuse is separated from 
> the hardware dependence.  Clock events and clocksources take care of 
> most of the timer issues, but there is still ugliness from SMP timer 
> events depending on having part of the APIC infrastructure for wiring 
> the interrupt gates.

what are you talking about? A clockevents driver does not need to know 
about lapic details, at all. In terms of interrupt gates for the 
hypervisor to notify about clock events - use a virtual interrupt 
controller via genirq.

if you want to use hardwired hardware details as your API: DO IT WITHOUT 
MODIFYING LINUX. If you want anything more intelligent, something more 
'paravirtual' - WORK WITH US AND WORK WITH THE OTHER HYPERVISORS. So far 
all i've seen from you was excuses and stonewalling on every step! We 
told you about the need to do VMI-timer ontop of clockevents last year 
already! You resisted virtually EVERY SINGLE cleanup suggestion since 
your stuff got upstream and you ONLY acted when a change was force-fed 
to you. Just count the number of emails you wrote, versus the patches 
you did. And your code is barely 2 weeks in! That is unacceptable.

	Ingo
