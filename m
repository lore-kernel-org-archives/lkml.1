Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZEKJci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZEKJci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZEKJc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:32:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZEKJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:32:27 -0400
Date: Mon, 11 May 2009 05:32:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v5 4/7] tracing: add kprobe-based event tracer
Message-ID: <20090511093224.GC23875@infradead.org>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004859.5505.18729.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509004859.5505.18729.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 08:48:59PM -0400, Masami Hiramatsu wrote:
> Add kprobes based event tracer on ftrace.
> 
> This tracer is similar to the events tracer which is based on Tracepoint
> infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
> and kretprobe). It probes anywhere where kprobes can probe(this means, all
> functions body except for __kprobes functions).

That's some pretty cool functionality, especially together with patch 7.

But as with so many tracing bits in the kernel it's just lowlevel bits
without a good user interface.  We'd really need some high-level way
for sysadmins/developers to use it.  E.g. a version of the systemtap
compiler that doesn't build a kernel module but instead uses the event
tracer + the kprobes tracer.

Or a model like Tom's zedtrace where a perl script would do the dwarf
lookups and generates these probes in addition to the filtered event
traces.

