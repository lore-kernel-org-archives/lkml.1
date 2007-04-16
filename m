Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXDPKWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXDPKWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXDPKWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:22:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336AbXDPKWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:22:47 -0400
Date: Mon, 16 Apr 2007 12:22:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: surya.prabhakar@wipro.com, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, npiggin@suse.de, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, wli@holomorphy.com,
       Greg KH <gregkh@suse.de>
Subject: Re: [TEST RESULT]massive_intr.c -- cfs/vanilla/sd-0.40
Message-ID: <20070416102219.GA3950@elte.hu>
References: <1176540546.2702.15.camel@bluegenie> <20070414120220.GA2346@elte.hu> <877iscsp1x.wl%takeuchi_satoru@jp.fujitsu.com> <20070416084724.GA10912@elte.hu> <87647wsk2o.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87647wsk2o.wl%takeuchi_satoru@jp.fujitsu.com>
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


* Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:

> You are welcome. I can use larger machine by chance, and also tested 
> there just now.
> 
> Test environment
> ================
> 
>  - kernel:         2.6.21-rc6-CFS
>  - run time:       300 secs
>  - # of CPU:       12
>  - # of processes: 200 or 2400
> 
> Result
> ===================================
> 
>   +----------+-----------+-------+------+------+--------+
>   |   # of   |   # of    | avg   | max  | min  |  stdev |
>   |   CPUs   | processes |       |      |      |        |
>   +----------+-----------+-------+------+------+--------+
>   |          |       200 |  2250 | 2348 | 2204 |     64 |
>   | 12(ia64) +-----------+-------+------+------+--------+
>   |          |      2400 | 187.5 |  197 |  176 |    4.3 |
>   +----------+-----------+-------+------+------+--------+
> 
> Looks like good too.

yeah. The spread between min and max is 11%, the spread between stddev 
and avg is 2.2%, which is quite OK for so many tasks.

> BTW, I've a question. Actually this problem is fixed on CFS and DS. 
> However they are mostly written from scratch and doeesn't suitable for 
> stable version, for example 2.6.20.X. Can your other patch be 
> compromise for stable version? Although that patch is not perfect, but 
> I think it's preferable to leave it alone.

i'm afraid that small patch is not suitable for a general purpose Linux 
release (it hits interactivity way too much) - that's what this 
years-long struggle was about. But you could apply it to a special 
server-centric kernel.

	Ingo
