Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYIYPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYIYPtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYIYPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:49:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:24069 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYIYPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=TbrmzRhKC1duWa5bfMLvbTtUO9HhQG4enjvp2KntD5cPNAQdFpUa3Z4i+BSYH6wzOL
         v0m0Cs7nd1F2pLKmvceRWpnZ2gLAoxxhU3sWSu/oR/6vY1nUqGgPscTacUSmmyOr1LAm
         uDFPRde6U/UZpCLIsQvWaTKRXT6lqBvDIMghQ=
Date: Thu, 25 Sep 2008 18:49:19 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Message-ID: <20080925184919.016d8957@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
References: <48DB81BA.2050204@gmail.com>
	<20080925123802.GA6900@elte.hu>
	<48DBA683.8000708@gmail.com>
	<20080925180916.75d3c9ec@daedalus.pq.iki.fi>
	<c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 17:33:02 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/9/25 Pekka Paalanen <pq@iki.fi>:
> > IMHO this breaks the trace_seq handling. trace_seq may contain
> > the output of several entries, as far as they fit in it as a whole.
> > E.g. trace_seq_printf() does not print partial lines but returns 0,
> > so that the entry is not consumed right now. The user space reader
> > must consume trace_seq content, before trace_seq_printf()
> > is attempted again, hopefully with enough space in trace_seq to
> > succeed. See tracing_read_pipe().
> > print_line() callback works the same way. Returning 0 means "could
> > not print it this time, call me back later". You can't use that to
> > say "use the default output function instead". Note, that possibly
> > the default output function will fail, too, so it could actually
> > try many of the default output functions and still fail, eventually
> > leading by luck to the correct behaviour in most cases.
> > Note, that mmiotrace follows this convention: it deliberatly
> > returns 1 without processing when it wants the entry discarded, and
> > it returns 0 when there was not enough space to process the entry.
> > This is explained in my other email.
> 
> Hmm you're right. I didn't thought about the partial line which must
> not be printed.
> The problem is that with this convention, 0 means two things: "I will
> handle this entry
> later" or "I can't handle it".
> But if you return 0 because you can't handle it, and if the current
> len of the seq is 0, the
> pipe will be broken.

My understanding is that the pipe will be broken only, if the trace
framework believes tracing is disabled. Recall the discussion about
tracer_enabled = 0. Which is a bug, and I hoped Steven would have
commented on how to fix that properly.

Or was it fixed already, and this is a different issue?
I didn't notice.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
