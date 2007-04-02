Return-Path: <linux-kernel-owner+w=401wt.eu-S965985AbXDBWFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985AbXDBWFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965993AbXDBWFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:05:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33592 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965985AbXDBWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:05:12 -0400
Subject: Re: [PATCH 1/2] Generic Virtual Memmap suport for SPARSEMEM
From: Dave Hansen <hansendc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704021449200.2272@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
	 <1175547000.22373.89.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021351590.1224@schroedinger.engr.sgi.com>
	 <1175548924.22373.109.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021428340.2272@schroedinger.engr.sgi.com>
	 <1175550151.22373.116.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021449200.2272@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 15:05:05 -0700
Message-Id: <1175551505.22373.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 14:53 -0700, Christoph Lameter wrote:
> > > Well think about how to handle the case that the allocatiopn of a page 
> > > table page or a vmemmap block fails. Once we have that sorted out then we 
> > > can cleanup the higher layers.
> > 
> > I think it is best to just completely replace
> > sparse_early_mem_map_alloc() for the vmemmap case.  It really is a
> > completely different beast.  You'd never, for instance, have
> > alloc_remap() come into play.
> 
> What is the purpose of alloc_remap? Could not figure that one out.

That's what we use on i386 to get some lowmem area for non-zero NUMA
nodes.  Otherwise, all of ZONE_NORMAL is on node 0.  It's a bit hokey,
and stuff like virt_to_phys() probably doesn't work on it, but it has
worked pretty well for a long time.  

-- Dave

