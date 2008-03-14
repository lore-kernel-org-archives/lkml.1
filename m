Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYCNGkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYCNGkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 02:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYCNGj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 02:39:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45213 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbYCNGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:39:58 -0400
Date: Thu, 13 Mar 2008 23:39:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205472481.3215.268.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803132335120.24204@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang>  <1205465447.3215.195.camel@ymzhang>
 <1205472481.3215.268.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Zhang, Yanmin wrote:

> On tigerton, if I add "slub_max_order=3 slub_min_objects=16" to kernel 
> boot cmdline, the result is improved significantly and it takes just 
> 1/10 time of the original testing.

Hmmm... That means the updates to SLUB in mm will fix the regression that 
you are seeing because we there can use large orders of slabs and fallback
for all slab caches. But I am still interested to get to the details of
slub behavior on the 16p.

> So kmalloc-512 is the key.

Yeah in 2.6.26-rc kmalloc-512 has 8 objects per slab. The mm version 
increases that with a larger allocation size.

> Then, I tested it on stoakley with the same kernel commandline. 
> Improvement is about 50%. One important thing is without the boot 
> parameter, hackbench on stoakey takes only 1/4 time of the one on 
> tigerton. With the boot parameter, hackbench on tigerton is faster than 
> the one on stoakely.
> 
> Is it possible to initiate slub_min_objects based on possible cpu 
> number? I mean, cpu_possible_map(). We could calculate slub_min_objects 
> by a formular.

Hmmm... Interesting. Lets first get the details for 2.6.25-rc. Then we can 
start toying around with the slub version in mm to configure slub in such 
a way that we get best results on both machines.

