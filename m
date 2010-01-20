Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221Ab0ATJgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0ATJgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478Ab0ATJgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:36:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56254 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0ATJgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:36:00 -0500
Date: Wed, 20 Jan 2010 10:35:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
Message-ID: <20100120093555.GA24355@basil.fritz.box>
References: <4B560ACD.4040206@linux.vnet.ibm.com> <20100120004430.GA23484@basil.fritz.box> <4B566131.6020300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B566131.6020300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I agree.  Also it's easy to construct a system design that doesn't 
> have a hierarchical topology.  A simple example would be a cluster of 32 
> nodes, each of which is connected to its 31 neighbors.  Perhaps for the 

I doubt it's needed or useful to describe all details of an interconnect.

If detailed distance information is needed a simple table like
the SLIT table exported by ACPI would seem easier to handle.

But at least some degree of locality (e.g. "local memory controller")
would make sense.


> purposes of just enumerating PMUs, a tree might be sufficient, but it's not 
> clear to me that it is mathematically sufficient for all topologies, not to 
> mention if it's intuitive enough to use.  For example, 
> highly-interconnected components might require that PMU leaf nodes be 
> duplicated in multiple branches, i.e. PMU paths might not be unique in some 
> topologies.

We already have cyclical graphs in sysfs using symlinks. I'm not 
sure they are all that easy to parse/handle, but at least they
can be described.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
