Return-Path: <linux-kernel-owner+w=401wt.eu-S938802AbZDJPVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938802AbZDJPVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938668AbZDJPUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:20:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:64770 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938692AbZDJPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=is3AvVRjG+Cx/cpJKf2JY/E1tIs2PBFQSoE5dbtdvXjRPIJG288SFOVArF9lRI0v0v
         GvNFJGB0LXZbXrTpUdyaji0ODLze8SzuKnr4YDWJEgvGDj12sN9u1mDU+hIagz222Lyc
         lxiSfbiZvjN1C9LpQHHMUUQjh6iFAYh2VBoIU=
Date: Fri, 10 Apr 2009 18:21:22 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftrace: Separate include/trace/kmemtrace.h to
	kmemtrace part and tracepoint part
Message-ID: <20090410152121.GA5505@localhost>
References: <49DEE68A.5040902@cn.fujitsu.com> <20090410110303.GB21506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410110303.GB21506@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 01:03:03PM +0200, Ingo Molnar wrote:
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
> > Current kmemtrace.h is used both as header file of kmemtrace and kmem's
> > tracepoints definition.
> > Tracepoints' definition file may be used by other code, and should only have
> > definition of tracepoint.
> > 
> > We can separate include/trace/kmemtrace.h into 2 files:
> >   include/linux/kmemtrace.h: header file for kmemtrace
> >   include/trace/kmem.h:      definition of kmem tracepoints
> > 
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  include/linux/kmemtrace.h             |   25 +++++++++++++++++++++++++
> >  include/linux/slab_def.h              |    2 +-
> >  include/linux/slub_def.h              |    2 +-
> >  include/trace/{kmemtrace.h => kmem.h} |   25 +++----------------------
> >  init/main.c                           |    2 +-
> >  kernel/trace/kmemtrace.c              |    2 +-
> >  kernel/trace/trace.h                  |    2 +-
> >  mm/slab.c                             |    2 +-
> >  mm/slob.c                             |    2 +-
> >  mm/slub.c                             |    2 +-
> >  10 files changed, 36 insertions(+), 30 deletions(-)
> >  create mode 100644 include/linux/kmemtrace.h
> >  rename include/trace/{kmemtrace.h => kmem.h} (78%)
> 
> Pekka, Eduard, do you agree with these two patches? Converting those 
> tracepoints to TRACE_EVENT() is really nice. The above include file 
> restructuring makes sense too - it separates tracepoint definition 
> from the plugin init method.
> 
> 	Ingo

Yes, these two patches look great. The first one makes the kmem
tracepoints usable by other things (e.g. kmemcheck) in a
kmemtrace-independent fashion, which is nice. Thanks, Zhao.

One thing I don't actually get is why have kmem_event_types.h separate
from kmem.h, but it's not really an issue, I see other tracers doing the
same thing. Other than that, it looks fine although I didn't test. Here's
the ack if you need it:

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Pekka?


	Eduard

