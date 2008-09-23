Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYIWDF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYIWDF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbYIWDFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:05:51 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:59816 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbYIWDFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:05:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAH/510hMQWq+/2dsb2JhbACBXbUzgWY
Date: Mon, 22 Sep 2008 23:05:46 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Martin Bligh <mbligh@google.com>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, zanussi@comcast.net
Subject: Re: Unified tracing buffer
Message-ID: <20080923030546.GI24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <33307c790809220929l32427a1as3d6d6bc08ce3173b@mail.gmail.com> <1222101401.16700.48.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222101401.16700.48.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:04:26 up 110 days,  7:44,  7 users,  load average: 1.03, 1.08,
	0.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Mon, 2008-09-22 at 09:29 -0700, Martin Bligh wrote:
> > >> In conjunction with the previous email on this thread
> > >> (http://lkml.org/lkml/2008/9/22/160), may I suggest
> > >> the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:
> > >>
> > >> relay_printk(<some struct with default filenames/pathnames>, <string>,
> > >> ....) ;
> > >> relay_dump(<some struct with default filenames/pathnames>, <binary
> > >> data>);
> > >> and
> > >> relay_cleanup_all(<the struct name>); - Single interface that cleans up
> > >> all files/directories/output data created under a logical entity.
> > >
> > > Dude, relayfs is such a bad performing mess that extending it seems like
> > > a bad idea. Better to write something new and delete everything relayfs
> > > related.
> > 
> > There did seem to be pretty universal agreement that we'd rather not
> > use relayfs.
> > 
> > > Also, it seems prudent to separate the ring-buffer implementation from
> > > the event encoding/decoding facilities.
> > 
> > Right - in conversation I had with Mathieu later, he suggested cleaning up
> > relayfs - I fear this will delay us far too long, and get bogged down.
> > If we can get one clean circular buffer implementation, then both
> > relayfs and the tracing could share that common solution,
> 
> Currently only blktrace and kvmtrace use relayfs, and I've heard people
> talk about converting both to use lttng/ftrace infrastructure. At which
> point relayfs is orphaned and ready for removal.
> 

LTTng sits on top of relay for buffer allocation and for the mmap
operation (that's about it, it overrides the rest).

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
