Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbYKFPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYKFPc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYKFPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:32:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYKFPcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:32:47 -0500
Date: Thu, 6 Nov 2008 16:32:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, T?r?k Edwin <edwintorok@gmail.com>,
       srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081106153238.GD1644@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org> <20081106095547.GK4890@elte.hu> <20081106122650.GA23474@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106122650.GA23474@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Nov 06, 2008 at 10:55:47AM +0100, Ingo Molnar wrote:
> > > On Mon, Nov 03, 2008 at 08:32:57AM +0100, Ingo Molnar wrote:
> > > > could you please help out with such a helper? This is really about 
> > > > visualization, not to rely on it.
> > > 
> > > Is this kindergarten? [...]
> > 
> > No, this is lkml where, if you decide to stand in the way of a patch, 
> > you are supposed to back up your NAK's with a path out of that NAK. 
> > Instead of forcing people into multiple email ping-pongs trying to 
> > figure out what exactly the objections mean.
> 
> Even if that was true, which would be avery sad world I should be 
> easy enough for you or anyone to look at what seq_path does and how 
> to have a version that doesn't use the seq_file insterface.  Takes 
> about two minutes with most of the time spent on finding where 
> seq_file is implemented.

the timeline i quoted shows that it was a 2 days process, not 2 
minutes.

It's the basic principle of communication: be forgiving in what you 
receive and conservative in what you transmit. Plus if one extra 
sentence of seemingly redundant information increases the chances to 
save an email-roundtrip down the line then please do it to increase 
communication efficiency and reduce latency.

Just to show you an example, let me give you an analogous situation in 
scheduler talk, as a reply to someone from another field who tries to 
use an existing scheduler API the wrong way:

 "
   Hey, you loser, NAK. Sync wakeups are the wrong thing to do, why 
   dont you just disable buddy wakeups for a minute in sched.c??

   [ Only two minutes to write a patch. The solution is really
     obvious to me, and we are not in the kindergarten to explain
     everything to you. And besides, the longer i make it for you to
     figure it all out, the cooler i can feel about being an
     ueber-capable scheduler hacker ;-) ]
 "

do you want such a world? i dont ;-)

	Ingo
