Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYKZDIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYKZDIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYKZDIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:08:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYKZDIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:08:05 -0500
Date: Wed, 26 Nov 2008 04:07:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       mingo@redhat.com
Subject: Re: [RFC] Reentrant clock sources
Message-ID: <20081126030720.GC8242@elte.hu>
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se> <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > +	cycle_t (*vread)(struct clocksource *cs);
> 
> This is crap. vread can not access the clocksource.

i think 'reentrant' in the sense of creating self-sufficient driver 
entities. vread wont (and shouldnt) call ->vread() recursively - but 
it might want to access fields on the clocksource.

this way more dynamic clocksource drivers could be written. Am i 
missing something?

	Ingo
