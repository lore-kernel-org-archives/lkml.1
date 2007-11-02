Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXKBBG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXKBBG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXKBBGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:06:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43192 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754072AbXKBBGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:06:18 -0400
Date: Thu, 1 Nov 2007 18:06:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071101.155805.65012933.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711011759400.24589@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
 <20071101.153824.91808126.davem@davemloft.net>
 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
 <20071101.155805.65012933.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, David Miller wrote:

> You cannot put limits of the amount of alloc_percpu() memory available
> to clients, please let's proceed with that basic understanding in
> mind.  We're wasting a ton of time discussing this fundamental issue.

There is no point in making absolute demands like "no limits". There are 
always limits to everything. 

A new implementation avoids the need to allocate per cpu arrays and also 
avoids the 32 bytes per object times cpus that are mostly wasted for small 
allocations today. So its going to potentially allow more per cpu objects
that available today.

A reasonable implementation for 64 bit is likely going to depend on 
reserving some virtual memory space for the per cpu mappings so that they 
can be dynamically grown up to what the reserved virtual space allows.

F.e. If we reserve 256G of virtual space and support a maximum of 16k cpus 
then there is a limit on the per cpu space available of 16MB.
