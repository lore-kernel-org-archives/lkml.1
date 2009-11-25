Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZKYRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZKYRqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbZKYRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:46:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933AbZKYRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:46:36 -0500
Date: Wed, 25 Nov 2009 18:41:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 0/3] tracepoint: Add signal events
Message-ID: <20091125174101.GA18349@redhat.com>
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com> <20091123175740.GA15594@elte.hu> <20091124212247.GA11773@redhat.com> <20091124213727.GA11347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124213727.GA11347@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Sorry, I can't really comment these patches.
> >
> > I mean, I do not know which info is useful and which is not. For
> > example, I am a bit surprized we report trace_signal_lose_info() but
> > please do not consider this as if I think we shouldn't. Just I do not
> > know.
>
> well, there we lose information, so it's basically an exception/anomaly
> that a person doing analysis might be interested in.
>
> > OTOH, we do not report if __send_signal() fails just because the
> > legacy signal is already queued. [...]
>
> We could do that (beyond the queued signals full event), but i think
> it's rather common to see signal overlap in the legacy case, right?

Yes, right. My point was, we do not know if people want to know
about "lost" signal in this case. Perhaps some application forgot
to unblock the signal, or the sender shouldn't send it, or the
reciever didn't react to the previous one.

But once again, I do not argue. I think the patches are nice and
useful. All I wanted to say is: I trust Masami and I have no idea
whether we need more or less info, and which events are more
"interesting".

> > [...] We do not report who sends the signal, [...]
>
> The PID of any task generating an event can be sampled, so that's
> implicit.

Yes, I missed this. If current != sender (timers, SIGIO) one can
look at entry->code = si_code.

> The principe is this: there's two extremes:
>
>  A- report no event
>
>  B- report every event precisely, that allows all signal state and
>     actions to be reconstructed in hindsight.
>
> And there's a continuum between the two extremes. Just a random state
> between A) and B) makes little sense - but certain subsets (say an
> 'overview' of major signal events) might make sense from an analysis
> POV.
>
> But the thing is, by my reading of these patches we are pretty close to
> B) right now and the tracepoints still look sane - so we might as well
> implement your suggestions and achieve B)? That's a well-defined target
> to achieve. It would mean we need events of sigmask manipulations as
> well, and handler setting events. Plus the missing events you pointed
> out. (plus other stuff i might have forgotten about)

Fortunately, Roland has already replied:

	> If we
	> need to change them, that will become clear from the experiences of people
	> actually using these.

In fact, the above is very close to what I meant but failed to explain ;)

Oleg.

