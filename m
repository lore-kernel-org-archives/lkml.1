Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZETWNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZETWNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZETWNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:13:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZETWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:13:38 -0400
Date: Wed, 20 May 2009 18:13:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] tracing: add __print_flags for events
In-Reply-To: <20090518173854.GA30425@infradead.org>
Message-ID: <alpine.DEB.2.00.0905201810300.1080@gandalf.stny.rr.com>
References: <20090515210342.488025506@goodmis.org> <20090515210717.745370400@goodmis.org> <20090518173854.GA30425@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 18 May 2009, Christoph Hellwig wrote:
> Some small comments:
> 
>  - __print_flags might be a little to generic.  What about trace_print_flags?

The __print_flags is not a macro nor a function. It is similar to 
__field() and __array() and __string(). It is a place holder that will be 
overriden by the ftrace.h magic.

I'll keep it as __print_flags since it follows format with the other tags.

>  - some documentation would help.  I can submit a patch to the
>    trave_events sample module to make use of it once this patch is
>    merged.
>  - Maybe passing an array instead of a list of flag/value pairs would be
>    a tad cleaner?  That would get rid of all the varargs mess and allow
>    to declare that array next to the flags so get less easily out of
>    sync.

OK, this may even save space. By passing by parameters we must load all 
the parameters before calling the function. Even though this is on the 
print side, it is still bloated. I'll convert it to an array.

Thanks,

-- Steve

