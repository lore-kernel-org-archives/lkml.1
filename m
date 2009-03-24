Return-Path: <linux-kernel-owner+w=401wt.eu-S1751029AbZCXF3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbZCXF3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZCXF3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:29:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44824 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZCXF3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:29:31 -0400
Date: Tue, 24 Mar 2009 10:59:26 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Rostedt <rostedt@goodmis.org>, Steven@e28smtp08.in.ibm.com,
       utrace-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090324052926.GC24018@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321050422.d1d99eec.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 05:04:22AM -0700, Andrew Morton wrote:
> On Sat, 21 Mar 2009 07:51:41 -0400 "Frank Ch. Eigler" <fche@redhat.com> wrote:
> > On Sat, Mar 21, 2009 at 04:19:54AM -0700, Andrew Morton wrote:
> 
> I have strong memories of being traumatised by reading the uprobes code. 

That was a long time ago wasn't it? :-)

That approach was a carry over from an implementation from dprobes that
used readdir hooks. Yes, that was not the most elegant approach, as such
has long been shelved.

> What's the story on all of that nowadays?

Utrace makes implementing uprobes more cleaner. We have a prototype that
implements uprobes over utrace. Its per process, doesn't use any
in-kernel hooks, etc. It currently has a kprobes like interface (needs a
kernel module), but it shouldn't be difficult to adapt it to use
utrace's user interfaces (syscalls?) when those come around. The current
generation of uprobes that has all the bells and whistles can be found at
http://sources.redhat.com/git/gitweb.cgi?p=systemtap.git;a=tree;f=runtime/uprobes2

However, there are aspects of the current uprobes that can be useful to
any other userspace tracer: instruction analysis, breakpoint insertion
and removal, single-stepping support. With these layered on top of
utrace, building userspace debug/trace tools that depend on utrace
should be easier, outside of ptrace.

Work is currently on to factor these layers out. The intention is to
upstream all the bits required for userspace tracing once utrace gets
in, along with an easy to use interface for userspace developers
(a /proc or /debugfs interface?) -- one should be able to use it on
its own or with SystemTap, whatever they prefer. Details are still hazy
at the moment.

But, utrace is the foundation to do all of that.

Ananth
