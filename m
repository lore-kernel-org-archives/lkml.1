Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0BCKdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:33:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:39354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab0BCKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:33:42 -0500
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
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 11:33:16 +0100
Message-ID: <1265193196.24455.390.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> - event injection support

I like the idea, I'm just not sure about the name and API details.

I would like to call it something like collection support, and the API
should have an iterator like interface. 

That is, it should not blindly dump all events from a collection at
once, praying the output buffer is large enough, but either dump a
specified number and/or stop dumping when the buffer is full. Allowing a
second invocation to continue where it left off after the buffer content
has been consumed.

Which brings us to the ioctl() interface, we can do the above using
ioctl()s, but it seems to me we're starting to get ioctl() heavy and
should be looking at alternative ways of extending this.

Anybody any bright ideas?

