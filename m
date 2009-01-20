Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbZATSY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbZATSY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZATSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:24:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43884 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZATSYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:24:19 -0500
Date: Tue, 20 Jan 2009 16:23:57 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHv2] ftrace interface for blktrace
Message-ID: <20090120182357.GN690@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090116181611.GE6562@ghostprotocols.net> <20090117190913.GA17722@elte.hu> <20090117191430.GA30821@kernel.dk> <20090117200804.GJ6562@ghostprotocols.net> <20090120144219.GH690@ghostprotocols.net> <alpine.DEB.1.10.0901201007060.2681@gandalf.stny.rr.com> <20090120175835.GM690@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120175835.GM690@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 20, 2009 at 03:58:35PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Jan 20, 2009 at 12:03:17PM -0500, Steven Rostedt escreveu:
> > > @@ -163,23 +206,33 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
> > >  
> > >  	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
> > 
> > Do we still use relay?
> 
> blkFtrace is an addition to the existing method for the moment, as soon
> as we're all satisfied with functionality + performance, we may then
> remove that code.

I guess that is not a clear answer, so lemme try again:

The relay code is only used if the old method of starting a blk trace
and setting up filters is used, i.e. the IOCTL method.

When we use the sysfs interface to do that we do not use the relay code
at all.

But most of the rest is shared.

Except for things like __trace_note_message and the interface provided
by the old blktrace code to insert annotations into the stream.

That will be provided by using standard ftrace methods such as
/t/trace_marker, as demonstrated by:

[root@f10-1 ~]# cat /t/trace_pipe & echo "bye, bye relay" > /t/trace_marker
[1] 1090
[root@f10-1 ~]#             bash-957   [000] 14727.302000: 0: bye, bye relay

- Arnaldo
