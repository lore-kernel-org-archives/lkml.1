Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZEFLD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZEFLD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEFLDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:03:50 -0400
Received: from verein.lst.de ([213.95.11.210]:48762 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZEFLDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:03:49 -0400
Date: Wed, 6 May 2009 13:02:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       srostedt@redhat.com, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506110258.GA24850@lst.de>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506105748.GE25203@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 12:57:48PM +0200, Ingo Molnar wrote:
> Nice! Needs also an Ack from PowerPC folks before we can do this. 
> The cross section to other powerpc code seems to be rather low.

cbe-oss-dev is the Cell list.

> > -config SPU_TRACE
> > -	tristate "SPU event tracing support"
> > -	depends on SPU_FS && MARKERS
> > -	help
> > -	  This option allows reading a trace of spu-related events through
> > -	  the sputrace file in procfs.
> 
> I think we should keep this option around.

Why?  trace_events that aren't enabled are extremly low overhead.
And most in the current tree are non-optional.

> > +# magic for the trace events
> > +CFLAGS_sched.o := -I$(src)
> 
> Steve, i'm wondering whether this type of Makefile hackery (caused 
> by modular tracepoints) could be eliminated ...

We would just have to include the header file with "" instead of <>.
But I remember Steve not liking this when we talked about it.

