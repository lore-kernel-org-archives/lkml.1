Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYCNVGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYCNVGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYCNVGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:06:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34596 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753590AbYCNVGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:06:22 -0400
Date: Fri, 14 Mar 2008 14:05:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205479741.3215.293.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803141401120.28115@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang>  <1205465447.3215.195.camel@ymzhang> 
 <1205472481.3215.268.camel@ymzhang>  <Pine.LNX.4.64.0803132335120.24204@schroedinger.engr.sgi.com>
 <1205479741.3215.293.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Zhang, Yanmin wrote:

> > Yeah in 2.6.26-rc kmalloc-512 has 8 objects per slab. The mm version 
> > increases that with a larger allocation size.
> Would you like to give me a pointer to the patch? Is it one patch, or many patches?

If you a git pull on the slab-mm branch off my VM tree on kernel.org then
you got all you need. There will be an update in the next days though 
since some of the data you gave me already suggests a couple of ways that
things may be made better.

> > Hmmm... Interesting. Lets first get the details for 2.6.25-rc. Then we can 
> > start toying around with the slub version in mm to configure slub in such 
> > a way that we get best results on both machines.
> Boot parameter "slub_max_order=3 slub_min_objects=16" could boost perforamnce
> both on stoakley and on tigerton.

Well the current slab-mm tree already does order 4 and min_objects=60 
which is probably overkill. Next git push on slab-mm will reduce that
to the values you found to be sufficient.
 
> So should we keep slub_min_objects scalable based on possible cpu 
> number? When a machine has more cpu, it means more processes/threads 
> will run on it and it will take more time when they compete for the same 
> resources. SLAB is such a typical resource.

We would have to do some experiments to see how cpu counts affect multiple 
benchmarks. If we can establish a consistent benefit from varying these
parameters based on processor count then we should do so. There is already
one example in mm/vmstat.c how this could be done.

