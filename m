Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYLHL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYLHL7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYLHL63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:58:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35612
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758631AbYLHL61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:58:27 -0500
Date: Mon, 08 Dec 2008 03:58:28 -0800 (PST)
Message-Id: <20081208.035828.41796136.davem@davemloft.net>
To: mingo@elte.hu
Cc: eranian@gmail.com, paulus@samba.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081208111153.GA12377@elte.hu>
References: <18747.23509.977047.540995@cargo.ozlabs.ibm.com>
	<7c86c4470812072318n33e27045k50490f180ecfd8c0@mail.gmail.com>
	<20081208111153.GA12377@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Dec 2008 12:11:53 +0100

> We did what we believe to be the right thing: we gave performance 
> counters the proper high-level abstraction they _deserve_, and we made 
> performance counters a prime-time Linux citizen as well.

Seperate counters that are read independently is fundamentally wrong,
no matter how many times you try to say it isn't.  In fact it has
been shown (repeatedly) that this abstraction is at the wrong level.

People want to correlate, and it's not possible to do that if the
counters are sampled seperately.

We also don't want half-megabyte PMU tables in the kernel, nor the
complex logic about how PMU counter X can configured when counter Y is
configured for event A.  All of that belongs in userspace.

We also want to support PMUs that do not generate an overflow
interrupt.

Really, all of the backlash these new patches have received is not
about how clean the abstraction is, but rather whether it can even
do the job properly.

And also, another part of the backlash is that the poor perfmon3
person was completely blindsided by this new stuff.  Which to be
honest was pretty unfair.  He might have had great ideas about
the requirements (even if you don't give a crap about his approach
to achieving those requirements) and thus could have helped avoid
the past few days of churn.

