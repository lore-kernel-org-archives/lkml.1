Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZBQVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZBQVhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBQVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:36:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZBQVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:36:56 -0500
Date: Tue, 17 Feb 2009 22:36:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Junio C Hamano <gitster@pobox.com>,
       =?utf-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>
Subject: Re: [PATCH] Add *.rej to .gitignore
Message-ID: <20090217213639.GA2949@elte.hu>
References: <499B1729.5040802@goop.org> <alpine.LFD.2.00.0902171315400.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902171315400.21686@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 17 Feb 2009, Jeremy Fitzhardinge wrote:
> > 
> > (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)
> 
> I really dont' think we should ignore .rej files. 
> 
> They are _error_ cases, after all. People want to know about 
> them. And if you don't want to see them, you should remove 
> them.

hm, ok. Still it would be nice to have some sort of commit-time 
reminder.

I _do_ notice .rej files because i have:

  chmod +x .git/hooks/pre-commit

in my repo and .rej files trigger the checks there.

But the pre-commit hook is pretty painful to use when merging 
upstream updates: in the upstream kernel there's tons of commits 
that scream out loud and i have to commit a second time via 'git 
commit -n'.

I'm still holding out and all the commits we do in our repo are 
.git/hooks/pre-commit-clean, but it's discomforting to see how 
much stuff goes into the kernel with basic problems.

Just do something like this:

   $ chmod +x .git/hooks/pre-commit

   $ git checkout -b tmp.test v2.6.28

   $ git merge --no-ff --no-commit v2.6.29-rc5
   [...]
   Automatic merge went well; stopped before committing as requested

   $ git commit 2>&1 | grep ' (line ' | wc -l
   5334

So 5334 lines with trivial problems were introduced in this 
cycle alone (and that only scratches the surface really) - 
that's about 0.5% of all new lines (we added about 1 million new 
lines in this cycle).

That rate is too high IMO and the noise makes it harder to use 
this tool.

	Ingo
