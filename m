Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZALSfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZALSfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZALSfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:35:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZALSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:35:45 -0500
Date: Mon, 12 Jan 2009 13:35:43 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: checkpatch warning of struct indentation
In-Reply-To: <c62985530901121009h372c805dj14c748c8f266235d@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901121323000.22796@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com> <c62985530901121009h372c805dj14c748c8f266235d@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 Jan 2009, Fr?d?ric Weisbecker wrote:

> 2009/1/12 Steven Rostedt <rostedt@goodmis.org>:
> >
> > Hi,
> >
> > I'm now seeing the following warnings from checkpatch:
> >
> > #325: FILE: kernel/trace/trace_stat.c:21:
> > +       void                    *stat;
> >
> > ERROR: "foo     *bar" should be "foo *bar"
> > #334: FILE: kernel/trace/trace_stat.c:27:
> > +       struct tracer_stat      *ts;
> >
> > ERROR: "foo             *bar" should be "foo    *bar"
> > #337: FILE: kernel/trace/trace_stat.c:30:
> > +       struct dentry           *file;
> 
> 
> Oh my patch :-)
> Yeah I had the same errors when I checked it. I ignored them because
> I because I remembered checkpatch.pl didn't warn about such things before.
> And it seems to warn about such statements since very recently...

Heh, I should have CC'd you on this complaint ;-)

Yeah, this is a new warning and since we do a lot of these types of
indentation, and they are marked as "ERROR", I would like to see these go 
away. Perhaps they need to test for parenthesis, so:

 int func(foo		*bar)

gets caught.


[off topic, funny English grammar]

I noticed that you said:

   And it seems to warn about such statements since very recently

This sounds strange. I know in German (and I know you are not German, but 
it's what I have most experience with) the word "seit" gets translated 
into "since" for such statements as above. A lot of Germans that I know 
make this funny sounding phrase. I would have written it like:

   And, recently, it seems to warn about such statements.

Don't take this as a criticism. I'm the last person to criticize anyone's 
grammar. For being an English speaking native, my grammar sucks ;-)
And your statement may indeed be correct grammar. It just sounds a little
funny to me.

In a lot of cases, (for Germans) "seit" can correctly be translated into
"since" but there are times that it just sounds funny.

A common phrase from Germans are:

  I've been doing this since three years.

Just an observation, carry on ;-)

-- Steve


> 
> 
> > This is for:
> >
> > struct tracer_stat_session {
> >        struct list_head        session_list;
> >        struct tracer_stat      *ts;
> >        struct list_head        stat_list;
> >        struct mutex            stat_mutex;
> >        struct dentry           *file;
> > };
> >
> > Which looks a hell of a lot better than:
> >
> > struct tracer_stat_session {
> >        struct list_head session_list;
> >        struct tracer_stat *ts;
> >        struct list_head stat_list;
> >        struct mutex stat_mutex;
> >        struct dentry *file;
> > };
> >
> > We probably do not want to warn on such things.
> >
> > -- Steve
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
