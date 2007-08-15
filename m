Return-Path: <linux-kernel-owner+w=401wt.eu-S935538AbXHOUjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935538AbXHOUjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbXHOUjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:39:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46231 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935963AbXHOUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:38:58 -0400
Date: Wed, 15 Aug 2007 13:38:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
In-Reply-To: <20070815163142.GA12850@vino.hallyn.com>
Message-ID: <Pine.LNX.4.64.0708151338140.7628@schroedinger.engr.sgi.com>
References: <20070814180339.GA32553@vino.hallyn.com> <1187115224.6281.40.camel@localhost>
 <20070814192306.GB32553@vino.hallyn.com> <20070814204951.GA2065@vino.hallyn.com>
 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
 <1187127685.6281.139.camel@localhost> <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
 <1187185392.5422.13.camel@localhost> <20070815143125.GA11582@vino.hallyn.com>
 <1187195028.5422.30.camel@localhost> <20070815163142.GA12850@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Serge E. Hallyn wrote:

> > Index: Linux/mm/page_alloc.c
> > ===================================================================
> > --- Linux.orig/mm/page_alloc.c	2007-08-15 10:01:23.000000000 -0400
> > +++ Linux/mm/page_alloc.c	2007-08-15 10:05:41.000000000 -0400
> > @@ -52,7 +52,14 @@
> >   */
> >  nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
> >  	[N_POSSIBLE] = NODE_MASK_ALL,
> > -	[N_ONLINE] = { { [0] = 1UL } }
> > +	[N_ONLINE] = { { [0] = 1UL } },
> > +#ifndef CONFIG_NUMA
> > +	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
> > +#ifdef CONFIG_HIGHMEM
> > +	[N_HIGH_MEMORY] = { { [0] = 1UL } },
> > +#endif
> > +	[N_CPU] = { { [0] = 1UL } },
> > +#endif	/* NUMA */
> >  };
> >  EXPORT_SYMBOL(node_states);

> Will let you know how it works.

The patch above looks like we are heading in the right direction.
