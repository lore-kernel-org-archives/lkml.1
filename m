Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZESNAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZESNAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZESNAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:00:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57331 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbZESNAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:00:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
References: <4A0BB813.9080807@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 19 May 2009 08:59:29 -0400
In-Reply-To: <4A0BB813.9080807@cn.fujitsu.com> (Li Zefan's message of "Thu, 14
	May 2009 14:20:03 +0800")
Message-ID: <x49ws8d45am.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizf@cn.fujitsu.com> writes:

> TRACE_EVENT is a more generic way to define tracepoints. Doing so adds
> these new capabilities to this tracepoint:

>   - zero-copy and per-cpu splice() tracing
>   - binary tracing without printf overhead
>   - structured logging records exposed under /debug/tracing/events
>   - trace events embedded in function tracer output and other plugins
>   - user-defined, per tracepoint filter expressions
>   ...
>
> Cons and problems:
>
>   - no dev_t info for the output of plug, unplug_timer and unplug_io events.

I'm not sure I'm comfortable with this.  Having had to diagnose
performance problems using blktrace, I find the dev_t information for
plugs and unplugs especially interesting.  Maybe we can still figure
this out given the context in the trace, though.  Can you comment on
that?

>     no dev_t info for getrq and sleeprq events if bio == NULL.
>     no dev_t info for rq_abort,...,rq_requeue events if rq->rq_disk == NULL.
>
>   - for large packet commands, only 16 bytes of the command will be output.
>     Because TRACE_EVENT doesn't support dynamic-sized arrays, though it
>     supports dynamic-sized strings.
>
>   - a packet command is converted to a string in TP_assign, not TP_print.
>     While blktrace do the convertion just before output.
>
>   - in blktrace, an event can have 2 different print formats, but a TRACE_EVENT
>     has a unique format. (see the output of getrq and rq_insert)
>
>
> Following are some comparisons between TRACE_EVENT and blktrace:
>
> plug:
>   kjournald-480   [000]   303.084981: block_plug: [kjournald]
>   kjournald-480   [000]   303.084981:   8,0    P   N [kjournald]

I'm not a big fan of having to change my scripts!  Why did you switch
from the single letter output to the verbose strings?  Am I just being a
curmudgeon?

I have one further question, which will expose my ignorance on this
implementation.  Would the proposed patch change the information
available to the blktrace utility, or is this just for users such as
systemtap?

Cheers,
Jeff
