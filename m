Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYKXV1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYKXV1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYKXV12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:27:28 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:5958 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYKXV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=CDwSHQlk5iSrMbueFWk5oiofMnRg/0UWS3z6ax7OJg8BjoKIXvEgkawTC6evviXjub
         bVnCz0/vcgNyrzzn4zIYPA5nbIpSLZ6GWExz3TAvPB+THADe8bx2ArSXDhUF5P55ZiyD
         s0ZrYWmR6FWW/CQyXlxrIBTfNfEYtvQmUFVzA=
Date: Mon, 24 Nov 2008 23:27:20 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Message-ID: <20081124232720.59312c0d@daedalus.pq.iki.fi>
In-Reply-To: <c62985530811241230x601a27e1w504b0564b9513a13@mail.gmail.com>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	<20081123212430.4f6700e9@daedalus.pq.iki.fi>
	<20081123193413.GB2794@elte.hu>
	<20081124221849.33c91bcf@daedalus.pq.iki.fi>
	<c62985530811241230x601a27e1w504b0564b9513a13@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008 21:30:24 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/11/24 Pekka Paalanen <pq@iki.fi>:
> >
> > Oh right, the busylooping bug when echoing into trace_marker,
> > I already forgot about that, since I couldn't reproduce it.
> > I guess there's nothing to do, until someone finds a way to
> > reproduce it.
> 
> 
> Hi Pekka.
> 
> Are you talking about this old bug that broke the pipe?
> If so, you fixed it yourself partially with a patch that corrected
> tracing_read_pipe.
> Another origin was the none tracer that set tracer_enabled to 0.
> But i has been fixed with the nop tracer.
> 
> Perhaps you are talking of something else?

Yeah, I'm talking about the shell spinning 90% in kernel and 10% in
user, I tried to explain it in the part you left out from the quote.
That is, doing 'echo foo > trace_marker' makes the shell/echo spin.
And this doesn't seem to be deterministic, or the exact triggering
sequence is too complex. I didn't notice any other adverse effects
than the shell getting stuck.

Maybe a corner case related to having only a single page in the
ring buffer... nah, more likely something unexpected under
trace_marker callbacks. Returning zero instead of error on
write(2) maybe... something that makes 'echo' retry again and
again, never succeeding or really failing.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
