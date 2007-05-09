Return-Path: <linux-kernel-owner+w=401wt.eu-S970148AbXEIDIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970148AbXEIDIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbXEIDIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:08:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53937 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754654AbXEIDIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:08:39 -0400
Date: Tue, 8 May 2007 20:08:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <46413A29.1000506@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705082005130.21580@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
 <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
 <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
 <4641353F.2000408@yahoo.com.au> <Pine.LNX.4.64.0705081954300.19976@schroedinger.engr.sgi.com>
 <46413A29.1000506@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Nick Piggin wrote:

> But that 4MB system might not even have 50 pages that you'd want to
> use for slab.

The problem here is that you trade off more objects (SLUB) against more 
flexibility (SLOB). We need some experiments with 4M systems to see how 
this works out. It may be better to be able to allocate more objects. I 
estimate that we will have a need for about 30 active slabs (note the 
low number comes about because SLUB will merge similar slabs together 
into one) on such a system. Most of those can have two pages. So you will 
likely still be better off with SLUB than SLOB.

