Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0BGRKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 12:10:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab0BGRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 12:10:52 -0500
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
 improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100203220735.GD5068@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265193196.24455.390.camel@laptop>  <20100203220735.GD5068@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Feb 2010 18:10:27 +0100
Message-ID: <1265562627.12224.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 23:07 +0100, Frederic Weisbecker wrote:
> 
> > 
> > Which brings us to the ioctl() interface, we can do the above using
> > ioctl()s, but it seems to me we're starting to get ioctl() heavy and
> > should be looking at alternative ways of extending this.
> > 
> > Anybody any bright ideas?
> > 
> 
> 
> Using ioctl, we can basically have such structure:
> 
> struct perf_inject_req {
>         int start; (in)
>         int len;   (in)
>         int *read;  (out)
> };
> 
> Using an idx will often imply rewalk a whole object list from
> the beginning, which is perfectly fine.
> 
> If you prefer an alternate syscall, I can make it. I've been
> told about ioctl drawbacks by the past, I personally think
> ioctl has not only drawbacks: it avoids a proliferation
> of syscalls. But that's how you prefer.

One thing we could do is add a PERF_TYPE_COLLECTION and have its read()
method do something else than regular counters would, that way we can
use read()/lseek()/stat() fd interface. The only trouble with that is
that doesn't use the 'regular' output buffer.

/me goes try and come up with yet another solution..

