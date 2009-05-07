Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZEGHyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZEGHyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZEGHy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:54:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEGHy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:54:27 -0400
Date: Thu, 7 May 2009 09:54:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090507075417.GA9836@elte.hu>
References: <20090506053324.GA31988@redhat.com> <20090506072756.GA17457@elte.hu> <20090507064120.GB15220@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507064120.GB15220@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/06, Ingo Molnar wrote:
> >
> > One small nit with the definition above: when using vertical spacing
> > (which really looks nice) we tend to put the asterix to the type
> > itself, not to the variable. I.e.:
> >
> > 	enum pid_type		wtype;
> > 	struct pid *		wpid;
> > 	int			wflags;
> >
> > ( This is done to separate the field name from the type - the
> >   pointer nature of the field is part of the type, not part of the
> >   name. )
> 
> Indeed, I like this more too. But checkpatch.pl disagrees!

That's probably a checkpatch bug mistaking * for multiplication - 
ignore checkpatch in that case and please report it to Andy 
Withcroft as well as well.

> > Regarding the patch itself: i guess we could do it as-is - but 
> > if you think there's regression risks, a safer approach would be 
> > to create 5-6 patches to build up all the structure parameters 
> > one by one.
> 
> Oh, I tried to do it this way first. But I got lost and decided to 
> make a single patch. Besides, if I make 6 patches I should try to 
> test each one...

One way to do it is to build-test them on a common config (say 
64-bit defconfig), and then boot test the final result. That makes 
it fully bisectable in 90% of the cases.

But ... it's really up to you. I'd be cautious out of box, as the 
quirk density in exit.c is still enormous and it's very easy to have 
some unintended side-effect.

	Ingo
