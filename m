Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZGUF4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZGUF4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZGUF4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:56:40 -0400
Received: from mail-yx0-f197.google.com ([209.85.210.197]:33260 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZGUF4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Nd6Rk4pdC5UysfwoZHI7C4BqVqanAxGVsjDw0d35bHKi4Ch6paY6z3pstB3kWFERf7
         aFgfIKtN1o6CQpmXQCRxmu5PMnPqiaE89vFVBoVlo6rB9s1piy6RO0DmcSgtjqbvBwlv
         kSHo/oOAIUO+IZM1FZ7ONa2pFq9qR5VowbD1M=
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A651DF2.3060403@cn.fujitsu.com>
References: <4A63D485.7030703@cn.fujitsu.com>
	 <alpine.DEB.2.00.0907201207390.7595@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.0907201230320.7595@gandalf.stny.rr.com>
	 <4A651907.1090805@cn.fujitsu.com>
	 <alpine.DEB.2.00.0907202131390.11494@gandalf.stny.rr.com>
	 <4A651DF2.3060403@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 00:56:36 -0500
Message-Id: <1248155796.6323.46.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 09:46 +0800, Li Zefan wrote:
> >> Proposal 2:
> >>
> >>   # cat filter
> >>   irq_handler_entry: irq == 5
> >>   irq_handler_exit: none
> >>   softirq_entry: vec == 1
> >>   softirq_exit: vec == 2
> > 
> > I like proposal 2, it is very intuitive.
> > 
> 
> Me too.

Me three.  It's nice to see all the filters for the subsystem in one
place without having to descend into the event subdirs.  It might also
be nice to see which events are enabled by looking at the subsystem
'enable' file too.  Or maybe the subsystem filter file should show only
filters for enabled events...

> 
> >> Which do you think is better? Or do you have some better idea?
> >>
> >> And in the failure case:
> >>
> >>   # echo 'irq == not_num' > filter
> >>   bash: echo: write error: Invalid argument
> >>
> >> 1:
> >>   # cat filter
> >>   (still shows filters in each event like above)
> >>
> >> or shows error message (the current behavior)
> > 
> > No need to show error messages of failed filter modifications in the 
> > "filter" file.
> > 
> >> 2:
> >>   # cat filter
> >>   irq == not_num
> >>   ^
> >>   parse_error: Couldn't find or set field in one of a subsystem's events
> > 
> > This looks good, BUT, it is too much. If you want to implement an error 
> > message like the above, it should probably be a "pr_info()" thing.
> > 
> 
> Yeah, I think it's too much too, but that's exactly what we have.
> And I posted a patch to remove those error messages, but Tom and
> Frederic didn't seem to like it:
> 
> 	http://lkml.org/lkml/2009/6/17/89

It made sense to me to overload the filter file for individual events
this way since error messages (which I still think are useful) and valid
filters are mutually exclusive.  But that's not the case for the
subsystem filter files, so for those maybe a filter_error file makes
sense.  Maybe for consistency, it also makes sense for the individual
events too - I don't really have a strong opinion either way.

Tom

