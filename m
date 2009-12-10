Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZLJVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZLJVbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbZLJVbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:31:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761581AbZLJVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:31:15 -0500
Date: Thu, 10 Dec 2009 16:30:39 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210213039.GA32064@redhat.com>
References: <20091210120332.GA5042@nowhere> <20091210141121.GB1436@elte.hu> <1260456803.2146.167.camel@gandalf.stny.rr.com> <20091210153845.GA28230@elte.hu> <y0md42magc1.fsf@fche.csb> <20091210175737.GB5256@elte.hu> <20091210180412.GB30999@redhat.com> <20091210183508.GB17986@elte.hu> <20091210185044.GC30999@redhat.com> <20091210201454.GA31461@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210201454.GA31461@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Dec 10, 2009 at 09:14:54PM +0100, Ingo Molnar wrote:
> [...]
> > A few thousand entries in a hash table is really not that big a deal.
> Except if it's a high-freq event and the huge hash table is kept in the 
> CPU cache all the time.

OK.  (For reference, an int->int hash table slot costs about 40 bytes,
so an L2 cache could carry quite a few of them.)


> Firstly, AFAICS each subsequent systemtap probe for the same event
> adds chaining overhead - and then you have to disambiguate back to
> the originating script.

Right, but at some point this kind of demultiplexing has to occur
somewhere along the line.  In practice, chaining a la kprobes or
tracepoints is negligible compared to the other costs.


> Secondly, is there a way for a single probe to multiplex its output
> to multiple apps? AFAICS that's only possible by running multiple
> scripts.

As in having multiple files to write to?  There's no easy & direct way
to do that right now (beyond unmerged per-cpu files in "bulk" mode).
One can have systemtap print data on multiple synthetic /proc/.../
files, but that has other tradeoffs.  Or one could demultiplex in user
space (for example by prefixing text lines, or using binary records).

 
> > The message we have received time, after time, after time was 
> > stronger: that a suitable interpreter was not going to be welcome in 
> > tree.  If this is relaxed (and perhaps even if not), we may prototype 
> > such a thing in the new year.
> 
> FYI, i suggested this to you 2-3 years ago.

OK, well, I hope that when the time comes, the messages will be less
mixed than usual. :)


- FChE
