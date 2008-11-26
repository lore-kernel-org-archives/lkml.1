Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYKZRJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYKZRJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYKZRJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:09:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYKZRJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:09:31 -0500
Date: Wed, 26 Nov 2008 12:09:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable
 output
In-Reply-To: <c62985530811260311k4237012asd27ebd8599328cea@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811261206120.26743@gandalf.stny.rr.com>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>  <20081126020459.GA16374@elte.hu> <c62985530811260311k4237012asd27ebd8599328cea@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Fr?d?ric Weisbecker wrote:

> 2008/11/26 Ingo Molnar <mingo@elte.hu>:
> > 1) Compression of non-nested calls into a single line.
> >
> >   Implementing this probably necessiates some trickery with the
> >   ring-buffer: we'd have to look at the next entry as well and see
> >   whether it closes the function call.
> 
> 
> I wanted to do so. That's not so easy, I guess I will not only have to read
> the next entry. I'll have to modify it to avoid the next entry to
> print a closing brace.

You could run a ring_buffer_read(iter->buffer_iter[iter->cpu], NULL)
and that will consume the next entry, so it will not print.

> But I don't think that would be a problem.
> Note with this method that if there is a context switch or an
> interrupt between the entry and
> the return of a leaf function, it will not anymore be considered as a non-nested
> function on its output.
> But the case would be rare enough, so I will apply this.

Yeah, we would not care about that case. In fact it may be best to keep it 
as is.

-- Steve

