Return-Path: <linux-kernel-owner+w=401wt.eu-S1766833AbXEBTrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766833AbXEBTrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766847AbXEBTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:47:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36933 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766833AbXEBTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:47:34 -0400
Date: Wed, 2 May 2007 12:47:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: suresh.b.siddha@intel.com, yanmin.zhang@intel.com,
       peter.xihong.wang@intel.com, arjan.van.de.ven@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Regression with SLUB on Netperf and Volanomark
In-Reply-To: <1178131409.23795.160.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705021243480.1543@schroedinger.engr.sgi.com>
References: <1178131409.23795.160.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Tim Chen wrote:

> We tested SLUB on a 2 socket Clovertown (Core 2 cpu with 2 cores/socket)
> and a 2 socket Woodcrest (Core2 cpu with 4 cores/socket).  

Try to boot with

slub_max_order=4 slub_min_objects=8

If that does not help increase slub_min_objects to 16.

> We found that for Netperf's TCP streaming tests in a loop back mode, the
> TCP streaming performance is about 7% worse when SLUB is enabled on
> 2.6.21-rc7-mm1 kernel (x86_64).  This test have a lot of sk_buff
> allocation/deallocation.

2.6.21-rc7-mm2 contains some performance fixes that may or may not be 
useful to you.
> 
> For Volanomark, the performance is 7% worse for Woodcrest and 12% worse
> for Clovertown.

SLUBs "queueing" is restricted to the number of objects that fit in page 
order slab. SLAB can queue more objects since it has true queues. 
Increasing the page size that SLUB uses may fix the problem but then we 
run into higher page order issues.

Check slabinfo output for the network slabs and see what order is used. 
The number of objects per slab is important for performance.

