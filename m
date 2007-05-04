Return-Path: <linux-kernel-owner+w=401wt.eu-S1031482AbXEDSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031482AbXEDSKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031488AbXEDSKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:10:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46582 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031482AbXEDSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:10:53 -0400
Date: Fri, 4 May 2007 11:10:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: "Chen, Tim C" <tim.c.chen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: RE: Regression with SLUB on Netperf and Volanomark
In-Reply-To: <1178298897.23795.195.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705041107290.23684@schroedinger.engr.sgi.com>
References: <9D2C22909C6E774EBFB8B5583AE5291C02786032@fmsmsx414.amr.corp.intel.com>
  <Pine.LNX.4.64.0705031937560.16542@schroedinger.engr.sgi.com>
 <1178298897.23795.195.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Tim Chen wrote:

> A side note is that for my tests, I bound the netserver and client to
> separate cpu core on different sockets in my tests, to make sure that
> the server and client do not share the same cache.  

Ahhh... You have some scripts that you run. Care to share?

This is no NUMA syste? Two processors in an SMP system?

So its likely an issue of partial slabs shifting between multiple cpus and 
if the partial slab is now used on the other cpu then it may be cache cold 
there. Different sockets mean limitations to FSB bandwidth and bad caching 
effects. I hope I can reproduce this somewhere.

