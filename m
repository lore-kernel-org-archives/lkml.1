Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXLAUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXLAUzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXLAUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:55:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbXLAUz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:55:27 -0500
Date: Sat, 1 Dec 2007 21:54:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: J??rn Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071201205456.GA8231@elte.hu>
References: <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201204747.GA6458@lazybastard.org>
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


* J??rn Engel <joern@logfs.org> wrote:

> Almost.  "-serial stdio" was missing.  Much better now.
> 
> stopped custom tracer.
> BUG: spinlock recursion on CPU#0, sh/953
>  lock: c030f280, .magic: dead4ead, .owner: sh/953, .owner_cpu: 0
> Pid: 953, comm: sh Not tainted 2.6.24-rc3-ge1cca7e8-dirty #2
>  [<c0103a04>] show_trace_log_lvl+0x35/0x54
>  [<c010450a>] show_trace+0x2c/0x2e
>  [<c0104e6d>] dump_stack+0x84/0x8a
>  [<c01ded7c>] spin_bug+0xa7/0xae
>  [<c01def14>] _raw_spin_lock+0x45/0xfa
>  [<c02a02b1>] _spin_lock_irqsave+0x68/0x7a
>  [<c01087e7>] pit_read+0x14/0x99
>  [<c0130ee9>] get_monotonic_cycles+0xf/0x2d

ah. You should mark pit_read() function as notrace. PIT clocksource is 
rare. (add the 'notrace' word to the function prototype)

	Ingo
