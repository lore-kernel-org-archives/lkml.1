Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZERRjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZERRjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZERRi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:38:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZERRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:38:55 -0400
Date: Mon, 18 May 2009 13:38:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] tracing: add __print_flags for events
Message-ID: <20090518173854.GA30425@infradead.org>
References: <20090515210342.488025506@goodmis.org> <20090515210717.745370400@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515210717.745370400@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 05:03:43PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Developers have been asking for the ability in the ftrace event tracer
> to display names of bits in a flags variable.
> 
> Instead of printing out c2, it would be easier to read FOO|BAR|GOO,
> assuming that FOO is bit 1, BAR is bit 6 and GOO is bit 7.
> 
> Some examples where this would be useful are the state flags in a context
> switch, kmalloc flags, and even permision flags in accessing files.
> 
> I included Frederic Weisbecker's idea of using a mask instead of bits,
> thus we can output GFP_KERNEL instead of GPF_WAIT|GFP_IO|GFP_FS.
> 
> I also included Li Zefan's idea of allowing the caller of __print_flags
> to add their own delimiter (or no delimiter) where we can get for
> file permissions rwx instead of r|w|x.

Looks good to me.

Some small comments:

 - __print_flags might be a little to generic.  What about trace_print_flags?
 - some documentation would help.  I can submit a patch to the
   trave_events sample module to make use of it once this patch is
   merged.
 - Maybe passing an array instead of a list of flag/value pairs would be
   a tad cleaner?  That would get rid of all the varargs mess and allow
   to declare that array next to the flags so get less easily out of
   sync.

