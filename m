Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXJAVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXJAVqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXJAVqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:46:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbXJAVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:46:14 -0400
Date: Mon, 1 Oct 2007 14:45:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-Id: <20071001144543.4cfa1e44.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710011432300.20107@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>
	<20070919033643.763818012@sgi.com>
	<200709280742.38262.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	<1191002119.18147.80.camel@lappy>
	<Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	<1191003950.18147.85.camel@lappy>
	<20070929011311.8b51dedb.akpm@linux-foundation.org>
	<1191055632.18147.101.camel@lappy>
	<20070929020049.f73f4aea.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710011354480.19779@schroedinger.engr.sgi.com>
	<20071001143047.238dfe49.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710011432300.20107@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 14:38:55 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 1 Oct 2007, Andrew Morton wrote:
> 
> > Do slab and slub use the same underlying page size for each slab?
> 
> SLAB cannot pack objects as dense as SLUB and they have different 
> algorithm to make the choice of order. Thus the number of objects per slab 
> may vary between SLAB and SLUB and therefore also the choice of order to 
> store these objects.
> 
> > Single data point: the CONFIG_SLAB boxes which I have access to here are
> > using order-0 for radix_tree_node, so they won't be failing in the way in
> > which Peter's machine is.
> 
> Upstream SLUB uses order 0 allocations for the radix tree.

OK, that's a relief.

> MM varies 
> because the use of higher order allocs is more loose if the mobility 
> algorithms are found to be active:
> 
> 2.6.23-rc8:
> 
> Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg\
> radix_tree_node          14281     552     9.9M     2432/948/1    7 0  38  79

Ah.  So the already-dropped
slub-exploit-page-mobility-to-increase-allocation-order.patch was the
culprit?
