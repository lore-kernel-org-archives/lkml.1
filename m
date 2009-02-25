Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZBYEZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZBYEZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZBYEZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:25:16 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:36358 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753296AbZBYEZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:25:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2hk9fzTZaqJEGlsVzZFA2//0DHY55IVHG92G5BwqhLqDhZS1qdUGPvPCONwq1Fg6V3d/Q4k6XMiktnzBR6QrGJr9p4zEiBm3qic1rcE5jsCuUq6wxRk5YQAJStkne3g7PSroX1VXSAC9zaxxU3AeknUUr/dXBehun2/QoBhd9Ok=  ;
X-YMail-OSG: 8dQkdRgVM1ne2M_s3iVwrdqM9hxXs3mHL1B4wa5KMYqmr10mzYO3Hz_MhAZGEJFmU77o86Jrr1sxOgk.tuf7euBwuwWWXGEVQXaNW1aHJmdSZxQNZRtyajfXEbhelwe1e2kX5tlzrc.fvYZKCMhHB8WCcUMwytX5iAMCSq_clxACnuGQZK55Gu9rKdSTCUOLWqMunuQEN_r7.OAehTqxRSE08Hg0.SFz
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Date: Wed, 25 Feb 2009 15:24:35 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
References: <20090225025608.956691460@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251524.37542.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 15:08:56 Steven Rostedt wrote:
> On Tue, 24 Feb 2009, Andrew Morton wrote:
> > On Tue, 24 Feb 2009 21:56:10 -0500 Steven Rostedt <rostedt@goodmis.org> 
wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > >
> > > This patch creates the event tracing infrastructure of ftrace.
> > > It will create the files:
> > >
> > >  /debug/tracing/available_events
> > >  /debug/tracing/set_event
> > >
> > > The available_events will list the trace points that have been
> > > registered with the event tracer.
> > >
> > > set_events will allow the user to enable or disable an event hook.
> > >
> > > example:
> > >
> > >  # echo sched_wakeup > /debug/tracing/set_event
> > >
> > > Will enable the sched_wakeup event (if it is registered).
> > >
> > >  # echo "!sched_wakeup" >> /debug/tracing/set_event
> > >
> > > Will disable the sched_wakeup event (and only that event).
> >
> > Why not
> >
> > echo sched_wakeup > /debug/tracing/set_event
> > echo sched_wakeup > /debug/tracing/clear_event
>
> I'm trying to keep the number of files in /debug/tracing down.

Why? Andrew's proposal is much cleaner. (what is the !sched_wakeup
event? An event you get when the scheduler does not wake up a task? ;)


