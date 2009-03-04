Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZCDEpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZCDEpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 23:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZCDEpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 23:45:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZCDEpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 23:45:04 -0500
Date: Tue, 3 Mar 2009 23:45:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
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
In-Reply-To: <49AE05CD.9000402@zytor.com>
Message-ID: <alpine.DEB.2.00.0903032343140.7904@gandalf.stny.rr.com>
References: <20090304024921.153061228@goodmis.org> <20090304025251.015368537@goodmis.org> <20090303193501.0055e329.akpm@linux-foundation.org> <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com> <49AE05CD.9000402@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Mar 2009, H. Peter Anvin wrote:

> Steven Rostedt wrote:
> > > Conventionally a read() system call will return the number of bytes
> > > copied, and will only return -EFOO if the number of bytes copied was
> > > zero.
> > > 
> > > Lots of parts of the kernel break this, but it's usually device drivers
> > > and scruffy pseudo files, in which case a partial file read doesn't
> > > make much sense.  This doesn't make the broken behaviour right, but at
> > > least we have a bit of a weaselly excuse in that case.
> > 
> > I just went by the read man page:
> > 
> >        EFAULT buf is outside your accessible address space.
> 
> Yes, and that is the correct value if no bytes were copied.

Yuck. IMHO I rather have a read return a failure to my user app if I'm 
trying to write to more than I allocated. I guess I can change it, but it 
just seems to be hiding a bug in a user app.

-- Steve

