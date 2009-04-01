Return-Path: <linux-kernel-owner+w=401wt.eu-S1764267AbZDAMZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764267AbZDAMZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764195AbZDAMZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:25:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764187AbZDAMZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:25:22 -0400
Date: Wed, 1 Apr 2009 14:25:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/filters: add run-time field descriptions to
	TRACE_EVENT_FORMAT events
Message-ID: <20090401122516.GH12966@elte.hu>
References: <1238390524.6368.64.camel@bookworm> <20090330103808.GB6058@nowhere> <1238474638.10508.51.camel@bookworm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238474638.10508.51.camel@bookworm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> > Oh, do you know why these unfiltered event are disappearing?
> 
> It's because of the way ring_buffer_discard() currently works - 
> the filtered events are still there in the ring buffer taking up 
> space; they just aren't visible in the output because the read 
> skips over them.
> 
> So if there's a high volume of events being recorded, any given 
> event can be quickly overwritten before it has a chance to be 
> read, or it may have been read and appeared in the output, but 
> between the time it was read and the next cat, could easily have 
> been overwritten, and therefore 'disappears' on the next cat.
> 
> It's really no different from the normal case where there is no 
> filtering in place - the same thing would happen but you wouldn't 
> notice whether a particular event was still there or not the next 
> time you cat'ed the file, because of the large volume of events 
> being displayed. It's just more apparent when most of the events 
> are discarded and invisible.
> 
> At least that's my theory based on my understanding of how the 
> ring-buffer works...

Correct, and this needs to be fixed.

	Ingo
