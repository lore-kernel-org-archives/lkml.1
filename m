Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXA3ORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXA3ORx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXA3ORx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:17:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:51748 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965458AbXA3ORw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=CMt+SvvMOH9cOy83lTPZ0cn88+S0hVrmhYxFz0y+yIaVErdQFl2E+PgxEqcB6EuzmS6tIRyG5yOIYVOGMKfvOTuqk8J/JKwadMb7zrGR+7D2T1fQgusNb8JRC+PH25SWcYdhEHEQzVWMlTrj0/+LzHu2kNUo5Mqjd0RrwSfgY4E=
Date: Tue, 30 Jan 2007 14:17:46 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [-mm patch] BUG at net/sunrpc/svc.c:128 (was Re: 2.6.20-rc6-mm2)
Message-ID: <20070130141746.GD10257@slug>
References: <20070129001207.71ea3470.akpm@osdl.org> <20070129112141.GC2990@slug> <20070129093247.54ba43c9.akpm@osdl.org> <Pine.LNX.4.64.0701290948090.28644@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701290948090.28644@schroedinger.engr.sgi.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 09:49:50AM -0800, Christoph Lameter wrote:
> On Mon, 29 Jan 2007, Andrew Morton wrote:
> 
> > >  static int
> > >  svc_pool_map_init_percpu(struct svc_pool_map *m)
> > >  {
> > > -	unsigned int maxpools = nr_node_ids;
> > > +	unsigned int maxpools = num_online_cpus();
> > >  	unsigned int pidx = 0;
> > >  	unsigned int cpu;
> > >  	int err;
> > 
> > Thanks.
> 
> Patch has the wrong solution as detailed in another message.
> 
> The line should be reverted to what it was before:
> 
>   unsigned int maxpools = highest_possible_processor_id()+1;
> 
Tested it, works as expected. Bit late I know :)

Regards,
Frederik
