Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYI3IxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYI3IxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYI3IxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:53:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34745 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYI3Iw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:52:59 -0400
Date: Tue, 30 Sep 2008 10:52:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new
	type of print_line
Message-ID: <20080930085241.GB10374@elte.hu>
References: <48E11E1E.7010001@gmail.com> <20080929221934.260306dd@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929221934.260306dd@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> On Mon, 29 Sep 2008 20:27:42 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Adapt mmiotrace to the new print_line type.
> > By default, it ignores (and consumes) types it doesn't support.
> > 
> > Acked-by: Pekka Paalanen <pq@iki.fi>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Ack!
> All four patches looking good.

thanks guys!

Steve's latest trace-ringbuffer code against -tip complicates life a 
little bit.

We dont yet know whether tip/tracing/ring-buffer is ready for wider 
consumption, so it's in a separate feature branch. These four patches 
conflict with the ring-buffer code quite widely.

So ... i did an optimistic merge approach: i merged these 4 patches 
ontop of the new tip/tracing/ring-buffer code, and have put it into a 
new tip/tracing/pipe branch:

 # f19d495: tracing/ftrace: adapt the boot tracer to the new print_line type
 # 92261f6: tracing/ftrace: adapt mmiotrace to the new type of print_line
 # 157190e: tracing/ftrace: fix pipe breaking
 # 92e359a: tracing/ftrace: change the type of the print_line callback

i'm merging this into tip/master for a bit of testing, but if it breaks 
something (or if i havent pushed it out yet) you can merge it locally 
too, by doing this ontop of tip/master:

  git-merge tip/tracing/pipe

it should merge up cleanly and you should be able to check the end 
result. (and send me any fixes for merge mistakes)

( Once it's all in reasonably well-tested shape it will all show up in 
  tip/master and you can stop dealing with tip/tracing/* sub-branches.)

	Ingo
