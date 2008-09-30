Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYI3NdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYI3NdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYI3NdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:33:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYI3NdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:33:07 -0400
Date: Tue, 30 Sep 2008 09:33:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new
 type of print_line
In-Reply-To: <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809300931180.1984@gandalf.stny.rr.com>
References: <48E11E1E.7010001@gmail.com>  <20080929221934.260306dd@daedalus.pq.iki.fi>  <20080930085241.GB10374@elte.hu>  <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com>  <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com>
 <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Sep 2008, Fr?d?ric Weisbecker wrote:

> 2008/9/30 Steven Rostedt <rostedt@goodmis.org>:
> >
> > OK, I'll nuke the ring_buffer_lock :-/
> >
> > The trace_pipe calls that and then calls print_trace_line which will
> > eventually lock the buffer again. This is a bug on my part. I'll fix that
> > today.
> >
> > Thanks,
> 
> Strange, I can't see any case where print_trace_line could call the
> ring_buffer_lock.
> Hmm, I will see in your patch.

Opps, I mean the find_next_entry_inc will do the lock.

The ring_buffer_lock locks all CPU buffers, and the find_next_entry_inc
will read from the ring buffer which will also lock the buffer. Hence
a deadlock.

-- Steve

> 
> Ingo, I just saw one damage from the merging, trace_empty() returns
> TRACE_TYPE_HANDLED. The type is wrong, it should return 1.
> It's not urgent since the value is the same. Should I send a patch for
> such a small error?
