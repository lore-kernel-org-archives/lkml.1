Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZJUWOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZJUWOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZJUWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:14:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61073 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZJUWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:14:05 -0400
Subject: Re: [PATCH 2/4] tracing: fix trace_seq_printf return value
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091021220204.GA2462@jolsa.redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
	 <1256135801-1849-3-git-send-email-jolsa@redhat.com>
	 <1256142035.18347.3133.camel@gandalf.stny.rr.com>
	 <20091021220204.GA2462@jolsa.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 18:14:07 -0400
Message-Id: <1256163247.18347.3544.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 00:02 +0200, Jiri Olsa wrote:
> On Wed, Oct 21, 2009 at 12:20:35PM -0400, Steven Rostedt wrote:
> > On Wed, 2009-10-21 at 16:36 +0200, Jiri Olsa wrote:
> > > I believe we want to return the number of written characters,
> > > instead of the available buffer length.
> > > 
> > > wbr,
> > > jirka
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > > ---
> > >  kernel/trace/trace_output.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > > index ed17565..e871125 100644
> > > --- a/kernel/trace/trace_output.c
> > > +++ b/kernel/trace/trace_output.c
> > > @@ -95,7 +95,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> > >  
> > >  	s->len += ret;
> > >  
> > > -	return len;
> > > +	return ret;
> > 
> > Actually the return value here is ambiguous. Returning len is actually
> > safer. It probably should only return 0 (buffer not big enough to write
> > to) or 1 (buffer is big enough).
> > 
> > Because this should actually return non zero:
> > 
> >   trace_seq_printf(s, "");
> > 
> > -- Steve
> > 
> > >  }
> > >  EXPORT_SYMBOL_GPL(trace_seq_printf);
> > >  
> >
> 
> I made the suggested fix, plus spot not used function.
> 
> ---
> Making trace_seq_printf return 0 if the trace oversizes the buffer's free
> space, 1 otherwise.  Removing not used trace_seq_vprintf function.

err, I hate to remove that function. This is a utility file that is
exported for other parts of the kernel to use. At least make that a
separate patch.

-- Steve


