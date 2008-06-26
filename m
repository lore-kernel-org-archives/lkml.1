Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYFZMtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYFZMtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbYFZMdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:33:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340AbYFZMdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:33:42 -0400
Date: Thu, 26 Jun 2008 14:33:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ftrace: prevent ftrace modifications while being
	kprobe'd
Message-ID: <20080626123329.GQ29619@elte.hu>
References: <485D45AB.3000405@gmail.com> <20080623201525.GA10386@elte.hu> <863e9df20806232029x6621ff13qd584591214e93d7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863e9df20806232029x6621ff13qd584591214e93d7f@mail.gmail.com>
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


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Hi Ingo,
> 
> On Tue, Jun 24, 2008 at 1:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > note that i had to do a number of fixups to themerge, and there was one
> > chunk which did not merge cleanly and i left it out for now:
> >
> > @@ -435,8 +502,12 @@ static void ftrace_replace_code(int enable)
> >                                continue;
> >
> >                        /* ignore updates to this record's mcount site */
> > -                       if (get_kprobe((void *)rec->ip))
> > +                       if (get_kprobe((void *)rec->ip)) {
> > +                               freeze_record(rec);
> >                                continue;
> > +                       } else {
> > +                               unfreeze_record(rec);
> > +                       }
> 
> I wonder why it conflicted during the merge. I notice that patch 4/4 
> has been applied before 3/4. Can you try reversing the order and see 
> if it works? Else I'll redo them.

best would be a delta patch against tip/master to fix up whatever is 
still missing.

	Ingo
