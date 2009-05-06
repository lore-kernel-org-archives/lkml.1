Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZEFLX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZEFLX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZEFLXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:23:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZEFLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:23:19 -0400
Date: Wed, 6 May 2009 13:23:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       srostedt@redhat.com, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506112301.GK25203@elte.hu>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu> <20090506110258.GA24850@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506110258.GA24850@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> On Wed, May 06, 2009 at 12:57:48PM +0200, Ingo Molnar wrote:
> > Nice! Needs also an Ack from PowerPC folks before we can do this. 
> > The cross section to other powerpc code seems to be rather low.
> 
> cbe-oss-dev is the Cell list.

( ... and linuxppc-dev. And since it's all a sub-architecture of 
  PowerPC and Cell changes go upstream via the PowerPC tree, it's 
  nice to have the attention (and acks) of generic-arch maintainers 
  as well (if they are interested). And even if it's OK, Ben and 
  Arnd obviously calls the shots when it comes to workflow details: 
  in which tree and how to queue it up. )

> > > -config SPU_TRACE
> > > -	tristate "SPU event tracing support"
> > > -	depends on SPU_FS && MARKERS
> > > -	help
> > > -	  This option allows reading a trace of spu-related events through
> > > -	  the sputrace file in procfs.
> > 
> > I think we should keep this option around.
> 
> Why?  trace_events that aren't enabled are extremly low overhead.
> And most in the current tree are non-optional.

It is general curtesy to maintain the old Kconfig structure and ease 
migration to a new facility.

Part of the "being nice" excercise ;-)

> > > +# magic for the trace events
> > > +CFLAGS_sched.o := -I$(src)
> > 
> > Steve, i'm wondering whether this type of Makefile hackery (caused 
> > by modular tracepoints) could be eliminated ...
> 
> We would just have to include the header file with "" instead of 
> <>. But I remember Steve not liking this when we talked about it.

Yeah. But changing Makefiles isnt particularly clean either ...

And adding -I$(src) can have side-effects: we often have a local 
foo.h while an include/linux/foo.h as well.

	Ingo
