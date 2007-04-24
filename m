Return-Path: <linux-kernel-owner+w=401wt.eu-S1423112AbXDXVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423112AbXDXVA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423102AbXDXVA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:00:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423112AbXDXVA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:00:28 -0400
Date: Tue, 24 Apr 2007 22:59:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-ID: <20070424205918.GA25383@elte.hu>
References: <20070327214919.800272641@goop.org> <20070327215827.871954359@goop.org> <20070423234910.50149faf.akpm@linux-foundation.org> <462E43A7.1050001@goop.org> <20070424105738.e0ce36a9.akpm@linux-foundation.org> <462E4969.6070802@goop.org> <20070424113222.ed2e1314.akpm@linux-foundation.org> <462E61F1.7060403@goop.org> <462E6778.7070305@goop.org> <1177447948.12796.66.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177447948.12796.66.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Tue, 2007-04-24 at 13:24 -0700, Jeremy Fitzhardinge wrote:
> 
> > And sched_clock's use of local_irq_save/restore appears to be absolutely
> > correct, so I think it must be triggering a bug in either the self-tests
> > or lockdep itself.
> 
> Why does sched_clock need to disable interrupts?

i concur. To me it appears not "absolutely correct" that someone 
apparently added local_irq_save/restore to sched_clock(), but "absolute 
madness". sched_clock() is _very_ performance-sensitive for the 
scheduler, do not mess with it.

	Ingo
