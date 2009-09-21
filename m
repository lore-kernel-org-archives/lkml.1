Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZIUHjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZIUHjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZIUHjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:39:12 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:64379 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZIUHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:39:12 -0400
Date: Mon, 21 Sep 2009 09:38:48 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] perf_counter/powerpc: Fix compilation after
 perf_counter_overflow change
Message-ID: <20090921073848.GA4649@osiris.boeblingen.de.ibm.com>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
 <928CFBE8E7CB0040959E56B4EA41A77EC69BA5E0@irsmsx504.ger.corp.intel.com>
 <20090921073043.GB24467@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921073043.GB24467@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 09:30:43AM +0200, Ingo Molnar wrote:
> 
> * Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> 
> > >-----Original Message-----
> > >From: Paul Mackerras [mailto:paulus@samba.org]
> > >Sent: Monday, September 21, 2009 8:45 AM
> > 
> > 
> > >Markus, please take care in future to mention it in the changelog if
> > >your patches touch definitions used by other architectures.  If you
> > >could go so far as to use grep a bit more and fix up other
> > >architectures' callsites for the things you're changing, that would be
> > >very much appreciated.  Thanks.
> > 
> > I'm sorry I missed that.
> > 
> > There's one more place in arch/sparc/.
> > The below patch should fix it, but I have no means to test it.
> 
> You also missed a third thing:
> 
> +static inline int
> +perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
> +                 unsigned int size, int nmi, int sample)               { }
> 
> an 'int' function returning void ...
> 
> Plus all the !PERF_COUNTERS branch of empty inlines is pointless - these 
> facilities are used by perfcounters code only. I fixed that too.

Hi Ingo,

did you fix all of these warnings for !PERF_COUNTERS?

include/linux/perf_counter.h: In function 'perf_output_begin':
include/linux/perf_counter.h:854: warning: no return statement in function returning non-void
include/linux/perf_counter.h: At top level:
include/linux/perf_counter.h:863: warning: 'struct perf_sample_data' declared inside parameter list
include/linux/perf_counter.h:863: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/perf_counter.h:868: warning: 'struct perf_sample_data' declared inside parameter list
