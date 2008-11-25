Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbYKYO4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbYKYO4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYKYOzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:55:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYKYOzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:55:53 -0500
Date: Tue, 25 Nov 2008 15:55:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, johnstul@us.ibm.com, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [RFC] Reentrant clock sources
Message-ID: <20081125145501.GC14147@elte.hu>
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
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


* Magnus Damm <magnus.damm@gmail.com> wrote:

> Hi everyone,
> 
> Is there any special reason behind the non-reentrant clock source 
> code? I'm writing some timer help code and getting the struct 
> clocksource as argument to the callbacks would make the code much 
> cleaner and better.

No, there's no real reason, and cleaner code is welcome :-)

Historically most clocksource drivers started out as static and 
standalone entities and hence they always knew how to access their own 
data structures. Passing in cs and generalizing it along that line is 
certainly cleaner.

I'd suggest to not do this by wide-scale breakage of the ->read() API 
though: please introduce a ->read2() method instead, and extend GTOD 
to make use of it if it's present. This way we can gradually migrate 
to ->read2() and then remove the ->read() method atomically once the 
conversion has been finished.

> Extending the callbacks to be able to start and stop clock sources 
> for improved power management would be good too in my opinion. Any 
> thoughts?
> 
> I realize that there are quite a few clock source drivers that need 
> to be modified, any recommendation on which tree to do it against 
> and how to split up the patch? Thanks.

the timer tree is in tip/auto-timers-next, integrated into tip/master:

    http://people.redhat.com/mingo/tip.git/README

and also propagated towards linux-next. Not much is pending at the 
moment so you can work against -git too if you prefer that.

	Ingo
