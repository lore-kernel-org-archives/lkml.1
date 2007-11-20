Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbXKTEHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbXKTEHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXKTEHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:07:33 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55003 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753665AbXKTEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:07:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPfrQUdMROHU/2dsb2JhbACBWw
Date: Mon, 19 Nov 2007 23:07:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 03/45] Generic CPU operations: Core piece
Message-ID: <20071120040729.GA25013@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011332.415903723@sgi.com> <20071120031751.GA21743@Krystal> <Pine.LNX.4.64.0711191927510.21689@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711191927510.21689@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:03:23 up 16 days,  9:08,  3 users,  load average: 0.50, 0.70,
	0.87
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 19 Nov 2007, Mathieu Desnoyers wrote:
> 
> > 
> > Very interesting patch! I did not expect we could mix local atomic ops
> > with per CPU offsets in an atomic manner.. brilliant :)
> > 
> > Some nitpicking follows...
> 
> Well this is a draft so I was not that thorough. The beast is getting too 
> big. It would be good if I could get the first patches merged that just 
> deal with the two allocators and then gradually work the rest.
> 
> > I think you could use extra () around old, new etc.. ?
> 
> Right.
> 
> > Same here.
> > 
> > > +	(x);					\
> > 
> > () seems unneeded here, since x is local.
> 
> But (x) is returned to the "caller" of the macro so it should be specially 
> marged.
> 

I don't think that it really matters.. the preprocessor already wraps
all the ({ }) in a single statement, doesn't it ?


Grepping for usage of ({ in include/linux shows that the return value is
never surrounded by supplementary ().

> > > + * In that case we can simply disable preemption which
> > > + * may be free if the kernel is compiled without preemption.
> > > + */
> > > +
> > > +#define _CPU_READ(addr)				\
> > > +({						\
> > > +	(__CPU_READ(addr));			\
> > > +})
> > 
> > ({ }) seems to be unneeded here.
> 
> Hmmm.... I wanted a consistent style.
> 

Since checkpatch.pl emits a warning when a one liner if() uses brackets,
I guess compactness of code is preferred to a consistent style.

Just my 2 cents though :)

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
