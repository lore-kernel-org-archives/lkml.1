Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZCDEqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZCDEqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 23:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZCDEq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 23:46:27 -0500
Received: from THUNK.ORG ([69.25.196.29]:54033 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZCDEq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 23:46:26 -0500
Date: Tue, 3 Mar 2009 23:46:14 -0500
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] tracing: add binary buffer files for use with
	splice
Message-ID: <20090304044614.GL32284@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Martin Bligh <mbligh@google.com>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Tom Zanussi <tzanussi@gmail.com>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Jason Baron <jbaron@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Jiaying Zhang <jiayingz@google.com>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
	mrubin@google.com, md@google.com,
	Steven Rostedt <srostedt@redhat.com>
References: <20090304024921.153061228@goodmis.org> <20090304025251.015368537@goodmis.org> <20090303193501.0055e329.akpm@linux-foundation.org> <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 10:43:16PM -0500, Steven Rostedt wrote:
> > Conventionally a read() system call will return the number of bytes
> > copied, and will only return -EFOO if the number of bytes copied was
> > zero.
> > 
> > Lots of parts of the kernel break this, but it's usually device drivers
> > and scruffy pseudo files, in which case a partial file read doesn't
> > make much sense.  This doesn't make the broken behaviour right, but at
> > least we have a bit of a weaselly excuse in that case.
> > 
> 
> I just went by the read man page:
> 
>        EFAULT buf is outside your accessible address space.
> 

What is normally done in this case if buf is within the addressable
space, but buf+x is not, where x < len, then read(fd, buf, len) will
fill copy as many characters it can into buf until it runs out of
valid addres space, and then return that count as a partial read.

      	     	    	     	    	 -  Ted
