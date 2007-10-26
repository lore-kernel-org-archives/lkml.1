Return-Path: <linux-kernel-owner+w=401wt.eu-S1765195AbXJZRdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765195AbXJZRdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbXJZRdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:33:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbXJZRc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:32:59 -0400
Date: Fri, 26 Oct 2007 19:32:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] De-constify sched.h
Message-ID: <20071026173246.GA7117@elte.hu>
References: <20071026081721.GA6244@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026081721.GA6244@localhost.sw.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Linus, please revert commit a8972ccf00b7184a743eb6cd9bc7f3443357910c aka
> "sched: constify sched.h" or apply the following patch instead.
> 
> [PATCH] De-constify sched.h

firstly, thank you for not Cc:-ing me. I learned about this revert only 
once it was done deal in Linus' tree. You objected to the patch 
originally when it was submitted to lkml, and plausible arguments were 
presented against your (bogus) objection:

   http://article.gmane.org/gmane.linux.kernel.janitors/14623

in that thread, two months ago, you essentially conceded Jan 
Engelhardt's argument by not replying to his points, so i kept Joe's 
patch. And now you continue this "discussion" by asking for a revert and 
not Cc:-ing me, Joe or Jan - which is quite sneaky.

> 1) Patch doesn't change any code here, so gcc is already smart enough
>    to "feel" constness in such simple functions.

the const markers indeed had no real purpose in terms of code generation 
(gcc can figure it out whether something is modified by an inline 
function), but they had a documentation/intent purpose, and they are 
plausible if a non-inlined function uses a const task struct in the 
future. For example any of these functions could be un-inlined and could 
use (internally) one of the remaining inlines - in that case code 
generation gets better from the constifying as well. There are also a 
good deal of helper functions around task struct which could be marked 
with const.

we do have other inline functions in include/linux/*.h with 'const' 
arguments, so marking arguments with const is not without precedent and 
this was pointed out to you in the original discussion.

> 2) There is no such thing as const task_struct. Anyone who think
>    otherwise deserves compiler warning.

-ENOPARSE. 'const struct task_struct *' says that the task struct is not 
supposed to be modified within that (inline) function. That _does_ make 
sense.

so unless i'm missing something, your request for revert was pretty 
rude, technically incorrect and you also tried to circumvent the normal 
course of discussion. I have no strong feelings either way technically 
(the patch is borderline - we dont actively pass around const 
task_struct pointers at the moment - but we could start doing so, if we 
had the constification), but i do have strong feelings against the kind 
of behavior you showed here.

	Ingo
