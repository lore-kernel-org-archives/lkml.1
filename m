Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZHYI73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZHYI73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZHYI71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:59:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZHYI70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:59:26 -0400
Date: Tue, 25 Aug 2009 10:59:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
Message-ID: <20090825085919.GB14003@elte.hu>
References: <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com> <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com> <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com> <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com> <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Justin Mattock <justinmattock@gmail.com> wrote:

> O.K. I feel better, deleted
> my system, and threw in a minimal built system
> with only the bare essentials to boot.
> (just to make sure things are correct).
> 
> unfortunately after building rc6 I'm still hitting
> this. really am not sure why this is happening.

Could you please double-check the bisection result by doing this:

 git revert af6af30c0f

on the latest kernel and seeing whether that fixes the lockup?

Bisections are very efficient and hence very sensitive as well to 
minimal errors. Just one small mistake near the end of a bisection 
can blame the wrong commit.

So the best way to double-check such 100%-triggerable crashes is to 
do the revert. I tried the revert and it can be done fine here.

[ _If_ that does not fix the bug then to save time you can 
   'backtrack' the bisection, instead of re-doing it completely. 
   I.e. you have your bisection log, re-check the final steps going 
   backwards. Once you find a discrepancy (i.e. a 'bad' point that 
   is 'good' or the other way around), redo the bisection log 
   commands up to that point and continue it up to the end. ]

	Ingo
