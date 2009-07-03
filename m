Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZGCJRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZGCJRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZGCJRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:17:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33910 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZGCJRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:17:00 -0400
Date: Fri, 3 Jul 2009 11:16:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lennart@poettering.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703091655.GB3902@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk> <20090703064518.GA30674@elte.hu> <20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Just a side-note, please run new patches through 
> > scripts/checkpatch.pl:
> > 
> >     total: 4 errors, 2 warnings, 0 checks, 294 lines checked
> 
> Given the code doesn't currently *work* yet but is a first draft 
> its hardly important and there are better uses of time than 
> playing checkpatch policeman.

Well i noticed such details in your final commits that go upstream 
as well - you dont appear to be making full use of the patch quality 
tools we have.

(Also, the patch carried your Signed-off-by - which we add if we 
consider patches worthy for upstream.)

I'd have made similar comments had a newbie submitted this patch as 
well - i dont think you should be held to lower standards than 
newbies - in fact by all means you should be held to a higher 
standard as you serve as a role model. I hope you dont regard 
constructive review feedback as 'policing' you.

Also, some of the warnings were relevant beyond pure stylistic 
details:

> >  - the copy_from_user() in vt_event_wait_ioctl() could be shortened 
> >    if we didnt pass in an unsigned long (which is pointless anyway).
> >    The cast to void __user * should be done in the ioctl 
> >    demultiplexer vt_ioctl(), and the ioctl ugliness should not 
> >    invade cleaner child functions such as vt_event_wait_ioctl().
> > 
> >  - same for vt_event_wait_ioctl() - it passes in a type damaged by 
> >    ioctl's limitations. Such type limitations and ioctl demuxing 
> >    artifacts should be kept local to vt_ioctl().
> 
> That had already occurred to me. The events should also become a 
> mask so you can wait for several at once. What I wanted to know 
> was whether such an interface actually meets Lennart's 
> requirements.

	Ingo
