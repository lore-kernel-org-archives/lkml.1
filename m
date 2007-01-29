Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbXA2Ru4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbXA2Ru4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXA2Ru4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:50:56 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:42580 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752535AbXA2Ruz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:50:55 -0500
Date: Mon, 29 Jan 2007 09:49:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [-mm patch] BUG at net/sunrpc/svc.c:128 (was Re: 2.6.20-rc6-mm2)
In-Reply-To: <20070129093247.54ba43c9.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701290948090.28644@schroedinger.engr.sgi.com>
References: <20070129001207.71ea3470.akpm@osdl.org> <20070129112141.GC2990@slug>
 <20070129093247.54ba43c9.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Andrew Morton wrote:

> >  static int
> >  svc_pool_map_init_percpu(struct svc_pool_map *m)
> >  {
> > -	unsigned int maxpools = nr_node_ids;
> > +	unsigned int maxpools = num_online_cpus();
> >  	unsigned int pidx = 0;
> >  	unsigned int cpu;
> >  	int err;
> 
> Thanks.

Patch has the wrong solution as detailed in another message.

The line should be reverted to what it was before:

  unsigned int maxpools = highest_possible_processor_id()+1;


 
> Christoph, can you pleeeeeze be more careful?  A few seconds inattention
> and a dopey copy-n-paste bug leads to large amounts of wasted time for
> other people.

Looks like I need to add another nr_cpu_ids? I did not realize that the 
same weird thing was done for cpus, sigh.
