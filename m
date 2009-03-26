Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZCZNiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZCZNiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZCZNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:37:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40527 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZCZNhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:37:54 -0400
Date: Thu, 26 Mar 2009 14:37:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090326133732.GA14822@elte.hu>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk> <49CAE4CB.3050000@cn.fujitsu.com> <20090326082939.GF27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326082939.GF27476@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > One is introduced by "block: get rid of the manual directory counting in blktrace"
> > (f48fc4d32e24c0b6a18aad30305d819bcc68c049). Two are "blktrace: port to tracepoints"
> > (5f3ea37c7716db4e894a480e0c18b24399595b6b). Both commits are in mainline.
> > 
> > Since 2 of the bugs will rarely happen in real-life, and the 3rd 
> > one is a small issue, and we were so close to the release of 
> > .29, so I sent the fixes for -tip tree but not mainline. But if 
> > we are going merge tip/blktrace to .31, I guess it's better to 
> > merge that 3 fixes to .30?
> 
> Since you are the person that worked on it most lately, your 
> opinion matters the most. What do you think, is it ready for 
> 2.6.30 or should it wait for .31?

Yeah. Li, Arnaldo, what do you think?

Delaying them would be quite painful at this stage though - the 
blktrace plugin conversion was done with (ahem) your initial support 
so the commits got (foolishly, in hindsight ;-) interwoven into 300 
commits of the 2.6.30 tracing tree.

Delaying them would also be technically baseless - there are no 
known regressions or bugs in this code. (If you know about bugs then 
please speak up so we can fix them! ;-)

At this last minute stage we can do two things: merge it now or if 
you NAK it then we'll rebase the last ~2 months of the tracing tree 
with hundreds of commits (sigh), destroy its true history in the 
process and eradicate the blktrace bits.

I'd like to avoid the second option if possible as it destroys real 
value (these changes are really nice improvements, a lot of work 
went into them and there's no open regressions so i can see no 
objective reason why they couldnt go upstream now) but it's your 
choice really, you maintain block/* :-)

	Ingo
