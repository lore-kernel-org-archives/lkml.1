Return-Path: <linux-kernel-owner+w=401wt.eu-S1765478AbXHXJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765478AbXHXJvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXHXJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:51:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50358 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861AbXHXJvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:51:08 -0400
Date: Fri, 24 Aug 2007 11:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com
Subject: Re: QUESTION: RT & SCHED & fork: ?MISSING EQUIV of
	task_new_fairfor RT tasks.
Message-ID: <20070824095102.GA3615@elte.hu>
References: <000501c7df67$a644c9e0$6501a8c0@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501c7df67$a644c9e0$6501a8c0@earthlink.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mitchell Erblich <erblichs@earthlink.net> wrote:

> Mike Galbraith wrote:
> > 
> > On Tue, 2007-08-14 at 12:28 -0700, Mitchell Erblich wrote:
> > > Group, Ingo Molnar, etc,
> > >
> > > Why does the rt sched_class contain fewer elements than fair?
> > > missing is the RT for .task_new.
> > 
> > No class specific initialization needs to be done for RT tasks.
> > 
> >         -Mike
> 
> 
> Mike, et al,
> 
>     one time:  I was told that this group likes bottom posts.

( Mike did not top-post, so why this comment? )

>     The logic of class independent code calling class scheduling 
>    dependent code, assumes that all functions are in ALL the class 
>    dependent sections.
> 
>     Minimally, if I agree with your above statement, I would assume 
>     that the function should still exist as a null type function. 
>     However, in reality, alot of RT class specific init is done. Just 
>     currently none of it is done in this non-existant function.

your original claim and these additional claims are both incorrect. What 
Mike said is true: there is nothing "missing", RT class tasks do not 
need any extra setup over what they already receive from the generic 
function. A NULL pointer for sched_class->task_new means: "do default 
setup, no class-specific setup needed". If you disagree with what we say 
then please send a fix-patch or quote the specific code that is missing 
something in your opinion.

	Ingo
