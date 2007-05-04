Return-Path: <linux-kernel-owner+w=401wt.eu-S1767555AbXEDAoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767555AbXEDAoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767554AbXEDAoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:44:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56627 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767552AbXEDAoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:44:21 -0400
Date: Thu, 3 May 2007 17:44:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Chen, Tim C" <tim.c.chen@intel.com>
cc: Tim Chen <tim.c.chen@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: RE: Regression with SLUB on Netperf and Volanomark
In-Reply-To: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705031740470.15240@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Chen, Tim C wrote:

> We are still seeing a 5% regression on TCP streaming with
> slub_min_objects set at 16 and a 10% regression for Volanomark, after
> increasing slub_min_objects to 16 and setting slub_max_order=4 and using
> the 2.6.21-rc7-mm2 kernel.  The performance between slub_min_objects=8
> and 16 are similar.

Ok. We then need to look at partial list management. It could be that the 
sequence of partials is reversed. The problem is that I do not really 
have time to concentrate on performance right now. Stability comes 
first. We will likely end up putting some probes in there to find out 
where the overhead comes from.

> > Check slabinfo output for the network slabs and see what order is
> > used. The number of objects per slab is important for performance.
> 
> The order used is 0 for the buffer_head, which is the most used object.
> 
> I think they are 104 bytes per object.

Hmmm.... Then it was not affected by slab_max_order? Try 
slab_min_order=1 or 2 to increase that?
