Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYHUGUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYHUGUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYHUGUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:20:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43510 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYHUGUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:20:32 -0400
Date: Thu, 21 Aug 2008 08:15:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       adobriyan@gmail.com, "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Message-ID: <20080821061512.GB14572@elte.hu>
References: <1912217169.25608.228.camel@ymzhang> <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com> <1219252901.8651.63.camel@twins> <200808210355.55597.nickpiggin@yahoo.com.au> <2c0942db0808201115v3025e5f6r6c882783fa9e29f3@mail.gmail.com> <1219264236.8651.76.camel@twins> <1219265798.8651.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219265798.8651.84.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Ok, people pointed out I got my promotion rules mixed up, I casted the 
> result of the division to signed, instead of ending up with a signed 
> division.
> 
> #define avg(x, y) ({                            \
>         typeof(x) _avg1 = (x);                  \
>         typeof(y) _avg2 = (y);                  \
>         (void) (&_avg1 == &_avg2);              \
>         (typeof(x))(_avg1 + ((long long)_avg2 - _avg1)/2); })

ok, could you please just send a patch that is local to sched.c and then 
we can let this kernel.h change play out independently? There's too many 
iterations of this and it's better to decouple the two.

	Ingo
